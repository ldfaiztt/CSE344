import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;
import java.util.Random;
import java.util.Scanner;


public class Main {
	
	private static final String FILENAME = "dbconn.properties";
	
	public static void main(String[] args) throws SQLException {
		DBConnection dbConn = new DBConnection(FILENAME);
		
		sqlInjectionExample(dbConn);
	}
	
	private static void sqlInjectionExample(DBConnection dbConn) throws SQLException {
		final String SQL_INJECTION = "1; DROP TABLE Dummy;";
		final String SELECT_QUERY = "SELECT * FROM R WHERE a = " + SQL_INJECTION;
		//final String SQL_INJECTION = "1;";
		dbConn.issueNonUnEscapedQuery(SELECT_QUERY);
	}
	
	/**
	 * Shows an example how to use Scanner to pause and create interleaves.
	 * 
	 * @param dbConn
	 * @throws SQLException
	 */
	private static void runInsertAndSelect(DBConnection dbConn) throws SQLException {
		dbConn.beginTransaction();
		Random rand = new Random();
		final String select = "SELECT * FROM R;";
		final String insert = "INSERT INTO R VALUES(?, ?);";
		Scanner scan = new Scanner(System.in);
		List<String> firstInsertArgs = Arrays.asList(new String[] { String.valueOf(rand.nextInt(1000000)), String.valueOf(rand.nextInt(1000000)) });
		System.out.println("Press enter to start...");
		scan.nextLine();
		dbConn.issueSelectQuery(select, null);
		
		System.out.println("Pausing in case we want to interleave. Press enter to continue...");
		System.out.println("About to insert: " + firstInsertArgs);
		scan.nextLine();
		dbConn.issueInsertQuery(insert, firstInsertArgs);
		
		System.out.println("Pausing in case we want to interleave. Press enter to continue...");
		scan.nextLine();
		dbConn.issueSelectQuery(select, null);
		
		System.out.println("Pausing in case we want to interleave. Press enter to continue...");
		scan.nextLine();
		dbConn.commitTransaction();
		scan.close();
	}

}
