import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.List;
import java.util.Properties;

public class DBConnection {

	private final String configFilename;

	private Properties configProps = new Properties();

	private String jSQLDriver;
	private String jSQLUrl;
	private String jSQLUser;
	private String jSQLPassword;

	private Connection conn;
	
	public DBConnection(final String configFilename) {
		this.configFilename = configFilename;
		try {
			openConnection();
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
	}

	private void openConnection() throws FileNotFoundException, IOException, InstantiationException, IllegalAccessException, ClassNotFoundException, SQLException {
		configProps.load(new FileInputStream(configFilename));

		jSQLDriver = configProps.getProperty("videostore.jdbc_driver");
		jSQLUrl = configProps.getProperty("videostore.imdb_url");
		jSQLUser = configProps.getProperty("videostore.sqlazure_username");
		jSQLPassword = configProps.getProperty("videostore.sqlazure_password");

		/* load jdbc drivers */
		Class.forName(jSQLDriver).newInstance();

		System.out.println("Openning connection to " + jSQLUrl + "...");
		
		/* open connections to the imdb database */
		conn = DriverManager.getConnection(jSQLUrl, // database
				jSQLUser, // user
				jSQLPassword); // password

		conn.setAutoCommit(false); // by default automatically commit after each
									// statement
		
		System.out.println("Connected to " + jSQLUrl + "!");
	}
	
	/**
	 * Issues a selection query to the database 
	 * 
	 * @param queryString
	 * @param argument
	 * @throws SQLException
	 */
	public void issueSelectQuery(final String queryString, final List<String> argument) throws SQLException {
		PreparedStatement preparedStatement = conn.prepareStatement(queryString);
		for (int i = 0; argument != null && i < argument.size(); i++) {
			preparedStatement.setString(i, argument.get(i));
		}
		ResultSet result = preparedStatement.executeQuery();
		while (result.next()) {
			StringBuilder row = new StringBuilder();
			row.append("[" + result.getString(1) + ", ");
			row.append(result.getString(2) + "]");
			System.out.println(row.toString());
		}
	}
	
	/**
	 * Inserts updates the database with the query
	 * 
	 * @precondition queryString must contain a valid relation
	 * @param queryString the SQL query
	 * @param arguments the argument
	 * @throws SQLException if there is something wrong with the database
	 */
	public void issueInsertQuery(final String queryString, final List<String> arguments) throws SQLException {
		PreparedStatement preparedStatement = conn.prepareStatement(queryString);
		if (arguments != null && arguments.size() > 0) {
			preparedStatement.setString(1, arguments.get(0));
			preparedStatement.setString(2, arguments.get(1));
		}
		System.out.println("executing: " + preparedStatement.toString());
		preparedStatement.executeUpdate();
	}
	
	public void beginTransaction() throws SQLException {
		PreparedStatement preparedStatement = conn.prepareStatement("SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; BEGIN TRANSACTION;");
		preparedStatement.executeUpdate();
		conn.setAutoCommit(false);
	}
	
	public void commitTransaction() throws SQLException {
		PreparedStatement preparedStatement = conn.prepareStatement("COMMIT TRANSACTION;");
		preparedStatement.executeUpdate();
		conn.setAutoCommit(true);
	}
	
	public void rollbackTransaction() throws SQLException {
		PreparedStatement preparedStatement = conn.prepareStatement("ROLLBACK TRANSACTION;");
		preparedStatement.executeUpdate();
		conn.setAutoCommit(true);
	}
	
	public void issueNonUnEscapedQuery(String queryString) throws SQLException {
		Statement searchStatement = conn.createStatement();
		ResultSet movie_set = searchStatement.executeQuery(queryString);
		System.out.println("Executed: " + queryString);
	}

}
