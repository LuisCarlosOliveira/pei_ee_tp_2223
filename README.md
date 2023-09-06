## StepUp Shoes Sales Report System - final project of Structured Data Processing

### Overview

StepUp Shoes is a flourishing footwear manufacturing company, producing an extensive range of shoes. Due to its remarkable growth in recent years, it has built a network of national partners ranging from individual sellers to stores retailing its products. In light of this expansion, StepUp Shoes intends for all its partners to submit monthly sales reports.

To streamline this process, the company has decided to provide an XML vocabulary to facilitate the integration of sales data from each partner. The partners are expected to implement a module in their IT systems capable of generating XML documents that adhere to this specified vocabulary.

### XML Vocabulary Details:

1. **General Information**: Seller's Tax Identification Number (NIF), name, address, fiscal year, and the month the document pertains to.
2. **List of Customers**: Includes customer's NIF (if not provided, it should display "End Consumer"), name, and address (country, city, and postal code).
3. **List of Products Sold**: Product code, name, current stock, and type.
4. **Sales Summary**: Total number of distinct products, total sales value, and number of distinct customers.
5. **Sales Details**: Invoice code, sale date, customer code, total sale value, and total discount applied. Each sale line should include the sale line number, product code, product quantity, total line value, and discount value applied.

### Technical Implementation:

Using the provided CSV data (which represents a subset of typical information from one of StepUp Shoes' partners), the following tasks are expected:

1. **Import to MongoDB**: Import the given data to a MongoDB document-oriented database.
2. **MongoDB Structuring**: Consider best practices for modeling data in MongoDB using documents and collections. The organization of this data must be ensured using transformation/uniformization operations like `find()` and `aggregate()`.
3. **Data Access**: Use Mongo Atlas to:
   - Import the data to a MongoDB database.
   - Enable the Data API on Mongo Atlas for HTTP access to stored data.
   - Develop necessary queries using `find()/aggregate()` to extract data for export.
4. **BaseX API**: Implement an API using BaseX to:
   - Retrieve the XML sales report for a specified month.
   - Get a list of customers who made purchases in a given period.

### System Flow:

When a client (e.g., Postman) sends an HTTP request to the BaseX API for a sales report of a specified month, BaseX communicates with the Mongo Atlas API using HTTP and sends the necessary MongoDB queries. The response, in JSON format, is then transformed by BaseX into an XML structured document according to the specified vocabulary before being sent back to the client.

#### System Visualization:
The provided figure illustrates the overall flow of the system. The client sends an HTTP request to BaseX, which then communicates with the Mongo Atlas Data API to obtain JSON data. This data is then converted to an XML format compliant with the given vocabulary and sent back to the client.
