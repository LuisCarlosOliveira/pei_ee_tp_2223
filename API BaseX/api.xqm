module namespace page = 'http://basex.org/examples/web-page';

declare 
%rest:path("getClientsByPurchaseDate")
%rest:GET
%rest:query-param("startDate", "{$startDate}")
%rest:query-param("endDate", "{$endDate}")
function page:getClientsByPurchaseDate($startDate as xs:string, $endDate as xs:string) {
  
    (: consulta mongoDB :)
    let $jsonData := '{
        "collection": "SalesReport",
        "database": "SalesData",
        "dataSource": "PEIEE",
        "filter": {"Data":{' ||
            '"$gte": { "$date": "' || $startDate || 'T00:00:00.000Z" },' ||
            '"$lt": { "$date": "' || $endDate || 'T00:00:00.000Z" }' ||
        '}' ||
    '},' ||
    '"projection": {}' ||
    '}'

    let $req := http:send-request(
      <http:request method='post'> 
        <http:header name="api-key" value="INSERT API KEY"/>
        <http:body media-type='application/json'/>
      </http:request>,
      "https://eu-west-2.aws.data.mongodb-api.com/app/data-swqwv/endpoint/data/v1/action/find",
      $jsonData
    )

    return 
      for $doc in $req[2]/json/documents/_ 
      return 
        <Client>
            <ClientID>{ data($doc/IdCliente) }</ClientID>
            <ClientName>{ data($doc/NomeCliente) }</ClientName>
            <City>{ data($doc/Cidade) }</City>
            <Country>{ data($doc/Pais) }</Country>
            <VATNumber>{ data($doc/NIF) }</VATNumber>
        </Client>
};

declare 
%rest:path("getSalesReport")
%rest:GET
%rest:query-param("year", "{$year}")
%rest:query-param("month", "{$month}")
function page:getSalesReport($year as xs:integer, $month as xs:integer) {
    
    (: Cálculo das datas :)
    let $start-date := fn:string-join(($year, format-number($month, '00'), '01T00:00:00.000Z'), '-')
    let $end-date := fn:string-join(($year, format-number($month + 1, '00'), '01T00:00:00.000Z'), '-')
    
    (: consulta mongoDB :)
    let $jsonData := '{
        "collection": "SalesReport",
        "database": "SalesData",
        "dataSource": "PEIEE",
        "filter": {"Data": {
                "$gte": { "$date": "' || $start-date || '" },
                "$lt": { "$date": "' || $end-date || '" }
            }},
        "projection": {}
    }'

    let $req := http:send-request(
      <http:request method='post'> 
        <http:header name="api-key" value="INSERT API KEY"/>
        <http:body media-type='application/json'/>
      </http:request>,
      "https://eu-west-2.aws.data.mongodb-api.com/app/data-swqwv/endpoint/data/v1/action/find",
      $jsonData
    )

    (: Cálculo de distinctProducts, distinctClients e  totalValue :)
    let $documents := $req[2]/json/documents/_
    let $distinctProducts := distinct-values($documents/linhasFatura/*/IdArtigo)
    let $distinctClients := distinct-values($documents/IdCliente)
    let $totalValue := sum($documents/totalFatura)

    return 
  <SalesReport>
    <Seller>
        <VATNumber>509765432</VATNumber>
        <Name>StepUp Shoes</Name>
        <Address>Rua Principal, 50</Address>
        <City>Lousada</City>
        <Country>Portugal</Country>
        <PostalCode>4620-001</PostalCode>
    </Seller>
    <FiscalYear>{$year}</FiscalYear>
    <Month>{$month}</Month>
    <DistinctProductCount>{count($distinctProducts)}</DistinctProductCount>
    <TotalSalesValue>{$totalValue}</TotalSalesValue>
    <DistinctClientCount>{count($distinctClients)}</DistinctClientCount>
    {
      for $doc in $documents
      return 
        <SaleDetail>
            <InvoiceID>{data($doc/__id)}</InvoiceID>
            <Date>{data($doc/Data)}</Date>
            <Client>
            <ClientID>{data($doc/IdCliente)}</ClientID>
            <VATNumber>{data($doc/NIF)}</VATNumber>
            <ClientName>{data($doc/NomeCliente)}</ClientName>
            <City>{data($doc/Cidade)}</City>
            <Country>{data($doc/Pais)}</Country>
            <PostalCode>{data($doc/CodigoPostal)}</PostalCode>
            </Client>
                {
                for $line in $doc/linhasFatura/_
                return 
                <LineItem>
                <Product>
                    <ArticleID>{data($line/IdArtigo)}</ArticleID>
                    <ArticleDescription>{data($line/DescArtigo)}</ArticleDescription>
                    
                    <CurrentStock>{data($line/StockAtual)}</CurrentStock>
                    </Product>
                    <Quantity>{data($line/Quantidade)}</Quantity>
                    <Value>{data($line/Valor)}</Value>
                    <DiscountAmount>{data($line/Desconto)}</DiscountAmount>
                    
                </LineItem>
                }
      
            <InvoiceTotal>{data($doc/totalFatura)}</InvoiceTotal>
        </SaleDetail>
    }
  </SalesReport>
};
