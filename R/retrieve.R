#' Retrieve Application Insights data
#'
#' This file retrieves data from application insights as a data.frame
#'
#'
#' @param query The Application Insights Kusto query, as a string
#' @param applicationId The Application Insights Application ID
#' @param apiKey The API Key for the given Application Insights instance
#' @param timespan The Application Insights timespan (can be overridden in
#'                 the query)
#' @return All data from the query in a data.frame
#' @export
ai_retrieve<-function(query,applicationId,apiKey,timespan="P1D")
{
    url<-paste("https://api.applicationinsights.io/v1/apps/",applicationId,"/query?timespan=",timespan,"&query=",URLencode(query,reserved=TRUE),sep="")
    httpResult<-GET(url,add_headers(.headers=c("x-api-key"=apiKey)))
    if (http_error(httpResult))
      stop("HTTP request failed.", content(httpResult,"text"))
    contentsJson<-jsonlite::fromJSON(content(httpResult,"text"))
    aiData<-as.data.frame(contentsJson$tables$rows)
    colnames(aiData)<-as.data.frame(contentsJson$tables$columns)$name
    aiData
}
