MODULE Articles
    ! ArticleCounter
    VAR num articleCounter;
    VAR bool positionFound:=FALSE;
    VAR num i:=1;
    VAR intnum getAD;
    VAR intnum setAD;
    CONST num MAX_ARTICLE_DESCRIPTION_DATA:=3;
    VAR string filename:="home:/LastUsedArticles.txt";
    VAR string data{MAX_ARTICLE_DESCRIPTION_DATA}:=[" "," "," "];
    VAR string header{MAX_ARTICLE_DESCRIPTION_DATA}:=["Article","Counter","CycleTime"];
    ! Max. column amount= 3 (Article,Counter,CycleTime) + 2
	
	!TODO Date and Cycletime is overwritten on the last article entries

    PROC initArticleCounter()
        CONNECT getAD WITH getArticleData;
        ISignalDO getADpulser,1,getAD;

        CONNECT setAD WITH setArticleData;
        ISignalDO setADpulser,1,setAD;
    ENDPROC

    TRAP getArticleData
        sendArticleData;
    ENDTRAP

    TRAP setArticleData
        setArticlesAndCounters;
    ENDTRAP

    PROC setArticlesAndCounters()
        ! Load articles from file
        FOR row FROM 1 TO MAX_ARTICLE_COUNTER DO
            lastArticleNames{row}:=ReadFromFile(filename,row,3);
            lastArticleCounters{row}:=ReadFromFile(filename,row,4);
        ENDFOR

        ! Get article counter
        i:=1;
        WHILE ((i<=MAX_ARTICLE_COUNTER) AND (positionFound=FALSE)) DO
            IF (lastArticleNames{i}=" ") THEN
                lastArticleNames{i}:=actualProgName;
                articleCounter:=i;
                positionFound:=TRUE;
            ELSEIF (lastArticleNames{i}=actualProgName) THEN
                articleCounter:=i;
                positionFound:=TRUE;
            ELSEIF ((NOT (lastArticleNames{i}=" ")) AND (i=MAX_ARTICLE_COUNTER)) THEN
                FOR j FROM 1 TO MAX_ARTICLE_COUNTER DO
                    IF (j<MAX_ARTICLE_COUNTER) THEN
                        lastArticleNamesTemp{j}:=lastArticleNames{j+1};
                        lastArticleCountersTemp{j}:=lastArticleCounters{j+1};
                    ENDIF
                    lastArticleNamesTemp{MAX_ARTICLE_COUNTER}:=actualProgName;
                    lastArticleNames{j}:=lastArticleNamesTemp{j};
                    lastArticleCounters{j}:=lastArticleCountersTemp{j};
                ENDFOR
                articleCounter:=MAX_ARTICLE_COUNTER;
                positionFound:=TRUE;
            ENDIF
            i:=i+1;
        ENDWHILE
        positionFound:=FALSE;
    ENDPROC

    PROC sendArticleData()
        IF (articleCounter>0) THEN
            ! Save counter for actual article to array
            lastArticleCounters{articleCounter}:=ValToStr(nCyclesShow);

            ! Set header
            WriteToFile filename,data,header,MAX_ARTICLE_DESCRIPTION_DATA,TRUE,TRUE,TRUE,FALSE;

            !TODO Save actual date+time in array like lastArticleCounters{i}
            FOR j FROM 1 TO MAX_ARTICLE_COUNTER DO
                data{1}:=lastArticleNames{j};
                data{2}:=lastArticleCounters{j};
                IF (j<=articleCounter) THEN
                    data{3}:=ValToStr(ctMean);
                    IF (j=MAX_ARTICLE_COUNTER) THEN
                        WriteToFile filename,data,header,MAX_ARTICLE_DESCRIPTION_DATA,FALSE,FALSE,TRUE,TRUE;
                    ELSE
                        WriteToFile filename,data,header,MAX_ARTICLE_DESCRIPTION_DATA,FALSE,FALSE,TRUE,FALSE;
                    ENDIF
                ELSE
                    data{3}:=" ";
                    IF (j=MAX_ARTICLE_COUNTER) THEN
                        WriteToFile filename,data,header,MAX_ARTICLE_DESCRIPTION_DATA,FALSE,FALSE,FALSE,TRUE;
                    ELSE
                        WriteToFile filename,data,header,MAX_ARTICLE_DESCRIPTION_DATA,FALSE,FALSE,FALSE,FALSE;
                    ENDIF
                ENDIF
            ENDFOR
            ! Send article information (counter + last used articles)
            FOR i FROM 1 TO MAX_ARTICLE_COUNTER DO
                tpWriteSocket lastArticleNames{i}+"::"+lastArticleCounters{i}+"::"+ValToStr(i-1),":a:";
            ENDFOR
        ENDIF
    ENDPROC
ENDMODULE