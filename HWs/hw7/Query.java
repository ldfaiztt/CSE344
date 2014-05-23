import java.util.Properties;
import java.util.Scanner;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import java.io.FileInputStream;

/**
 * Runs queries against a back-end database
 */
public class Query {
	private String configFilename;
	private Properties configProps = new Properties();

	private String jSQLDriver;
	private String jSQLUrl;
	private String jSQLCustomerUrl;
	private String jSQLUser;
	private String jSQLPassword;

	// DB Connection
	private Connection conn;
        private Connection customerConn;

	// Canned queries

	// LIKE does a case-insensitive match
	private static final String SEARCH_SQL =
		"SELECT * FROM movie WHERE name LIKE ('%' + ? + %') ORDER BY id";
	private PreparedStatement searchStatement;

	private static final String DIRECTOR_MID_SQL = "SELECT y.* "
					 + "FROM movie_directors x, directors y "
					 + "WHERE x.mid = ? and x.did = y.id";
	private PreparedStatement directorMidStatement;
	
	private static final String ACTOR_MID_SQL = "SELECT a.* "
			+ "FROM actor a, casts c "
			+ "WHERE a.id = c.pid AND c.mid = ?";
	private PreparedStatement actorMidStatement;

	private static final String REMAINING_RENTALS_SQL = 
			"SELECT ((SELECT max_num_rent FROM RentalPlan p WHERE p.pid = c.pid) - " +
			"(SELECT COUNT(*) FROM Rental r WHERE r.cid = c.cid AND r.status = 'open')) " +
			"FROM Customer c " +
			"WHERE c.cid = ?";
	private PreparedStatement remainingRentalsStetement;

	private static final String CUSTOMER_NAME_SQL = 
			"SELECT fname, lname FROM Customer WHERE cid = ?";
	private PreparedStatement customerNameStatement;

	private static final String PLAN_NUM_SQL = "SELECT p.pid " +
			"FROM RentalPlan p, Customer c " +
			"WHERE p.pid = c.pid AND c.cid = ?";
	private PreparedStatement planNumStatement;

	private static final String VALID_PLAN_SQL = 
			"SELECT pid FROM RentalPlan WHERE pid = ?";
	private PreparedStatement validPlanStatement;

	private static final String VALID_MOVIE_SQL = 
			"SELECT id FROM movie WHERE id = ?";
	private PreparedStatement validMovieStatement;

	private static final String RENTER_ID_SQL = 
			"SELECT cid FROM Rental WHERE mid = ? AND status = 'open'";
	private PreparedStatement RenterIDStatement;

	private static final String MOVIE_SQL = 
			"SELECT * FROM movie WHERE name LIKE ? ORDER BY id";
	private PreparedStatement moiveStatement;

	private static final String MOVIE_JOIN_DIRECTOR_SQL = 
			"SELECT m.id, d.fname, d.lname " +
			"FROM movie m, directors d, movie_directors md " +
			"WHERE m.id = md.mid AND d.id = md.did AND m.name LIKE ? " +
			"ORDER BY m.id";
	private PreparedStatement movieJoinDirectorStatement;

	private static final String MOVIE_JOIN_ACTOR_SQL = 
			"SELECT m.id, a.fname, a.lname " +
			"FROM movie m, actor a, casts c " +
			"WHERE m.id = c.mid AND a.id = c.pid AND m.name LIKE ? " +
			"ORDER BY m.id";
	private PreparedStatement movieJoinActorStatement;

	private static final String CHOOSE_PLAN_SQL = 
			"UPDATE Customer SET pid = ? WHERE cid = ?";
	private PreparedStatement choosePlanStatement;

	private static final String LIST_PLAN_SQL = "SELECT * FROM RentalPlan";
	private PreparedStatement listPlanStatement;

	private static final String RENT_MOVIE_SQL = 
			"INSERT INTO Rental VALUES(?, ?, CURRENT_TIMESTAMP, 'open')";
	private PreparedStatement rentMovieStatement;

	private static final String RETURN_MOVIE_SQL = 
			"UPDATE Rental SET status = 'closed' WHERE cid = ? AND mid = ?";
	private PreparedStatement returnMovieStatement;

	/* uncomment, and edit, after your create your own customer database */
	private static final String CUSTOMER_LOGIN_SQL = 
		"SELECT * FROM customer WHERE login = ? and password = ?";
	private PreparedStatement customerLoginStatement;

	private static final String BEGIN_TRANSACTION_SQL = 
		"SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; BEGIN TRANSACTION;";
	private PreparedStatement beginTransactionStatement;

	private static final String COMMIT_SQL = "COMMIT TRANSACTION";
	private PreparedStatement commitTransactionStatement;

	private static final String ROLLBACK_SQL = "ROLLBACK TRANSACTION";
	private PreparedStatement rollbackTransactionStatement;
	

	public Query(String configFilename) {
		this.configFilename = configFilename;
	}

    /**********************************************************/
    /* Connection code to SQL Azure. Example code below will connect to the imdb database on Azure
       IMPORTANT NOTE:  You will need to create (and connect to) your new customer database before 
       uncommenting and running the query statements in this file .
     */

	public void openConnection() throws Exception {
		configProps.load(new FileInputStream(configFilename));

		jSQLDriver   = configProps.getProperty("videostore.jdbc_driver");
		jSQLUrl	   = configProps.getProperty("videostore.imdb_url");
		jSQLCustomerUrl = configProps.getProperty("videostore.customer_url");
		jSQLUser	   = configProps.getProperty("videostore.sqlazure_username");
		jSQLPassword = configProps.getProperty("videostore.sqlazure_password");


		/* load jdbc drivers */
		Class.forName(jSQLDriver).newInstance();

		/* open connections to the imdb database */

		conn = DriverManager.getConnection(jSQLUrl, // database
						   jSQLUser, // user
						   jSQLPassword); // password
                
		conn.setAutoCommit(true); // by default automatically commit after each statement 

		/* You will also want to appropriately set the 
                   transaction's isolation level through:  
		   conn.setTransactionIsolation(...) */
		conn.setTransactionIsolation(Connection.TRANSACTION_SERIALIZABLE);

		/* Also you will put code here to specify the connection to your
		   customer DB.  E.g.

		   customerConn = DriverManager.getConnection(...);
		   customerConn.setAutoCommit(true); //by default automatically commit after each statement
		   customerConn.setTransactionIsolation(...); //
		*/
		
		/* open connections to the customer database */
		customerConn = DriverManager.getConnection(jSQLCustomerUrl, jSQLUser, jSQLPassword);
		customerConn.setAutoCommit(true); // by default automatically commit after each statement
		customerConn.setTransactionIsolation(Connection.TRANSACTION_SERIALIZABLE);
	}

	public void closeConnection() throws Exception {
		conn.close();
		customerConn.close();
	}

    /**********************************************************/
    /* prepare all the SQL statements in this method.
      "preparing" a statement is almost like compiling it.  Note
       that the parameters (with ?) are still not filled in */

	public void prepareStatements() throws Exception {
		searchStatement = conn.prepareStatement(SEARCH_SQL);
		directorMidStatement = conn.prepareStatement(DIRECTOR_MID_SQL);
		actorMidStatement = conn.prepareStatement(ACTOR_MID_SQL);

		/* uncomment after you create your customers database */
		customerLoginStatement = customerConn.prepareStatement(CUSTOMER_LOGIN_SQL);
		beginTransactionStatement = customerConn.prepareStatement(BEGIN_TRANSACTION_SQL);
		commitTransactionStatement = customerConn.prepareStatement(COMMIT_SQL);
		rollbackTransactionStatement = customerConn.prepareStatement(ROLLBACK_SQL);

		/* add here more prepare statements for all the other queries you need */
		// helper functions
		remainingRentalsStetement = customerConn.prepareStatement(REMAINING_RENTALS_SQL);
		customerNameStatement = customerConn.prepareStatement(CUSTOMER_NAME_SQL);
		planNumStatement = customerConn.prepareStatement(PLAN_NUM_SQL);
		validPlanStatement = customerConn.prepareStatement(VALID_PLAN_SQL);
		validMovieStatement = conn.prepareStatement(VALID_MOVIE_SQL);
		RenterIDStatement = customerConn.prepareStatement(RENTER_ID_SQL);

		// fast search
		moiveStatement = conn.prepareStatement(MOVIE_SQL);
		movieJoinDirectorStatement = conn.prepareStatement(MOVIE_JOIN_DIRECTOR_SQL);
		movieJoinActorStatement = conn.prepareStatement(MOVIE_JOIN_ACTOR_SQL);

		// list/choose plans
		choosePlanStatement = customerConn.prepareStatement(CHOOSE_PLAN_SQL);
		listPlanStatement = customerConn.prepareStatement(LIST_PLAN_SQL);

		// rent/return movies
		rentMovieStatement = customerConn.prepareStatement(RENT_MOVIE_SQL);
		returnMovieStatement = customerConn.prepareStatement(RETURN_MOVIE_SQL);
	}


    /**********************************************************/
    /* Suggested helper functions; you can complete these, or write your own
       (but remember to delete the ones you are not using!) */

	public int getRemainingRentals(int cid) throws Exception {
		/* How many movies can she/he still rent?
		   You have to compute and return the difference between the customer's plan
		   and the count of outstanding rentals */
		int num;

		remainingRentalsStetement.clearParameters();
		remainingRentalsStetement.setInt(1, cid);
		ResultSet num_set = remainingRentalsStetement.executeQuery();

		// no need if/else condition since the query always return a number
		num_set.next();
		num = num_set.getInt(1);

		num_set.close();
		return num;
	}

	public String getCustomerName(int cid) throws Exception {
		/* Find the first and last name of the current customer. */
		String name;

		customerNameStatement.clearParameters();
		customerNameStatement.setInt(1, cid);
		ResultSet name_set = customerNameStatement.executeQuery();

		name_set.next();
		name = name_set.getString(1) + " " + name_set.getString(2);

		name_set.close();
		return name;

	}

	public int getPlanNum(int cid) throws Exception {
		/* get the name of the plan the current customer is using */
		int num;

		planNumStatement.clearParameters();
		planNumStatement.setInt(1, cid);
		ResultSet num_set = planNumStatement.executeQuery();

		num_set.next();
		num = num_set.getInt(1);

		num_set.close();
		return num;
	}

	public boolean isValidPlan(int planid) throws Exception {
		/* Is planid a valid plan ID?  You have to figure it out */
		boolean isValid;
		
		validPlanStatement.clearParameters();
		validPlanStatement.setInt(1, planid);
		ResultSet valid_set = validPlanStatement.executeQuery();

		isValid = valid_set.next();

		valid_set.close();
		return isValid;
	}

	public boolean isValidMovie(int mid) throws Exception {
		/* is mid a valid movie ID?  You have to figure it out */
		boolean isValid;
		
		validMovieStatement.clearParameters();
		validMovieStatement.setInt(1, mid);
		ResultSet valid_set = validMovieStatement.executeQuery();

		isValid = valid_set.next();

		valid_set.close();
		return isValid;
	}

	private int getRenterID(int mid) throws Exception {
		/* Find the customer id (cid) of whoever currently rents the movie mid; return -1 if none */
		int cid;

		RenterIDStatement.clearParameters();
		RenterIDStatement.setInt(1, mid);
		ResultSet renter_set = RenterIDStatement.executeQuery();

		if (renter_set.next())
			cid = renter_set.getInt("cid");
		else
			cid = -1;

		renter_set.close();
		return cid;
	}

    /**********************************************************/
    /* login transaction: invoked only once, when the app is started  */
	public int transaction_login(String name, String password) throws Exception {
		/* authenticates the user, and returns the user id, or -1 if authentication fails */

		/* Uncomment after you create your own customers database */
		int cid;

		customerLoginStatement.clearParameters();
		customerLoginStatement.setString(1,name);
		customerLoginStatement.setString(2,password);
		ResultSet cid_set = customerLoginStatement.executeQuery();
		if (cid_set.next()) cid = cid_set.getInt(1);
		else cid = -1;
		cid_set.close();
		return(cid);
	}

	public void transaction_printPersonalData(int cid) throws Exception {
		/* println the customer's personal data: name, and plan number */
		beginTransaction();
		System.out.printf("Geeting, %s!\n", getCustomerName(cid));
		System.out.printf("With your current rental plan #%d, ", getPlanNum(cid));
		System.out.printf("you can still rent %d more movies.\n", getRemainingRentals(cid));
		commitTransaction();
	}


    /**********************************************************/
    /* main functions in this project: */

	public void transaction_search(int cid, String movie_title)
			throws Exception {
		/* searches for movies with matching titles: SELECT * FROM movie WHERE name LIKE movie_title */
		/* prints the movies, directors, actors, and the availability status:
		   AVAILABLE, or UNAVAILABLE, or YOU CURRENTLY RENT IT */

		searchStatement.clearParameters();
		ResultSet movie_set = searchStatement.executeQuery();
		while (movie_set.next()) {
			int mid = movie_set.getInt(1);
			System.out.println("ID: " + mid + " NAME: "
					+ movie_set.getString(2) + " YEAR: "
					+ movie_set.getString(3));
			/* do a dependent join with directors */
			directorMidStatement.clearParameters();
			directorMidStatement.setInt(1, mid);
			ResultSet director_set = directorMidStatement.executeQuery();
			while (director_set.next()) {
				System.out.println("\t\tDirector: " + director_set.getString(3)
						+ " " + director_set.getString(2));
			}
			director_set.close();

			/* now you need to retrieve the actors, in the same manner */
			actorMidStatement.clearParameters();
			actorMidStatement.setInt(1, mid);
			ResultSet actor_set = actorMidStatement.executeQuery();
			while (actor_set.next()) {
				System.out.println("\t\tActor: " + actor_set.getString(2)
						+ " " + actor_set.getString(3));
			}
			actor_set.close();

			/* then you have to find the status: of "AVAILABLE" "YOU HAVE IT", "UNAVAILABLE" */
			int renter = getRenterID(mid);
			System.out.print("\t\tStatus: ");
			if (renter == cid)
				System.out.println("YOU HAVE IT");
			else if (renter == -1)
				System.out.println("AVAILABLE");
			else
				System.out.println("UNAVAILABLE");
		}
		movie_set.close();
		System.out.println();
	}

	public void transaction_choosePlan(int cid, int pid) throws Exception {
	    /* updates the customer's plan to pid: UPDATE customer SET plid = pid */
	    /* remember to enforce consistency ! */
		beginTransaction();

		if (!isValidPlan(pid)) {
			rollbackTransaction();
			System.out.println("The plan specified is not valid.");
			return;
		}
		
		choosePlanStatement.clearParameters();
		choosePlanStatement.setInt(1, pid);
		choosePlanStatement.setInt(2, cid);
		choosePlanStatement.executeUpdate();

		int rr = getRemainingRentals(cid);
		if (rr < 0) {
			rollbackTransaction();
			System.out.println("You must return some movies first in order to " +
			                   "switch to the rental plan.");
		} else {
			commitTransaction();
		}
	}

	public void transaction_listPlans() throws Exception {
	    /* println all available plans: SELECT * FROM plan */
		ResultSet plan_set = listPlanStatement.executeQuery();
		while (plan_set.next()) {
			System.out.print(plan_set.getInt("pid"));
			System.out.printf("\t%-12s", plan_set.getString("pname"));
			System.out.printf("\t%d movies maxium ", plan_set.getInt("max_num_rent"));
			System.out.printf("\t$%.2f\n", plan_set.getDouble("monthly_fee"));
		}

		plan_set.close();
	}

	public void transaction_rent(int cid, int mid) throws Exception {
	    /* rent the movie mid to the customer cid */
	    /* remember to enforce consistency ! */
		beginTransaction();

		if (!isValidMovie(mid)) {
			rollbackTransaction();
			System.out.println("The movie specified is not valid.");
			return;
		}

		// first check if the customer has rented up to the maximum number 
		// of movies his/her plan allowed at this moment
		int rr = getRemainingRentals(cid);
		if (rr <= 0) {
			rollbackTransaction();
			System.out.println("You've rented up to the max number of movies " +
					"your plan allowed. Please return some movie first!");
			return;
		}

		// used for debug
		// Scanner scan = new Scanner(System.in);
		// scan.nextLine();

		// then check if the movie is available or 
		// if the customer has already rented it
		int renter = getRenterID(mid);
		if (renter != -1) {
			rollbackTransaction();

			if (renter == cid)
				System.out.println("You've rented this movie already.");
			else
				System.out.println("This movie is not available right now.");

			return;
		}

		// passed all the checks, so the customer is able to rent the movie
		rentMovieStatement.clearParameters();
		rentMovieStatement.setInt(1, cid);
		rentMovieStatement.setInt(2, mid);
		rentMovieStatement.executeUpdate();
		commitTransaction();
	}

	public void transaction_return(int cid, int mid) throws Exception {
	    /* return the movie mid by the customer cid */
		beginTransaction();

		if (!isValidMovie(mid)) {
			rollbackTransaction();
			System.out.println("The movie specified is not valid.");
			return;
		}

		// used for debug
		Scanner scan = new Scanner(System.in);
		scan.nextLine();
		scan.close();

		// check if the customer is renting the movie he/she specified
		int renter = getRenterID(mid);
		if (renter != cid) {
			rollbackTransaction();
			System.out.println("You are not renting this movie.");
			return;
		}

		// he/she is renting the movie, so returning is ok
		returnMovieStatement.clearParameters();
		returnMovieStatement.setInt(1, cid);
		returnMovieStatement.setInt(2, mid);
		returnMovieStatement.executeUpdate();
		commitTransaction();
	}

	public void transaction_fastSearch(int cid, String movie_title)
			throws Exception {
		/* like transaction_search, but uses joins instead of dependent joins
		   Needs to run three SQL queries: (a) movies, (b) movies join directors, (c) movies join actors
		   Answers are sorted by mid.
		   Then merge-joins the three answer sets */
		moiveStatement.clearParameters();
		moiveStatement.setString(1, "%" + movie_title + "%");
		ResultSet movie_set = moiveStatement.executeQuery();

		movieJoinDirectorStatement.clearParameters();
		movieJoinDirectorStatement.setString(1, "%" + movie_title + "%");
		ResultSet movie_director_set = movieJoinDirectorStatement.executeQuery();
		boolean join1HasMore = movie_director_set.next();

		movieJoinActorStatement.clearParameters();
		movieJoinActorStatement.setString(1, "%" + movie_title + "%");
		ResultSet movie_actor_set = movieJoinActorStatement.executeQuery();
		boolean join2HasMore = movie_actor_set.next();

		while (movie_set.next()) {
			int mid = movie_set.getInt(1);
			System.out.println("ID: " + mid + " NAME: "
					+ movie_set.getString(2) + " YEAR: "
					+ movie_set.getString(3));

			int cur_mid1;
			while (join1HasMore) {
				cur_mid1 = movie_director_set.getInt(1);
				if (cur_mid1 > mid)
					break;
				else if (cur_mid1 == mid)
					System.out.println("\t\tDirector: " + movie_director_set.getString(3)
							+ " " + movie_director_set.getString(2));
				
				join1HasMore = movie_director_set.next();
			}

			int cur_mid2;
			while (join2HasMore) {
				cur_mid2 = movie_actor_set.getInt(1);
				if (cur_mid2 > mid)
					break;
				else if (cur_mid2 == mid)
					System.out.println("\t\tActor: " + movie_actor_set.getString(2)
							+ " " + movie_actor_set.getString(3));
				
				join2HasMore = movie_actor_set.next();
			}
		}
		
		movie_set.close();
		movie_director_set.close();
		movie_actor_set.close();
	}


    /* Uncomment helpers below once you've got beginTransactionStatement,
       commitTransactionStatement, and rollbackTransactionStatement setup from
       prepareStatements(): */
	public void beginTransaction() throws Exception {
		customerConn.setAutoCommit(false);
		beginTransactionStatement.executeUpdate();	
	}

	public void commitTransaction() throws Exception {
		commitTransactionStatement.executeUpdate();
		customerConn.setAutoCommit(true);
	}

	public void rollbackTransaction() throws Exception {
		rollbackTransactionStatement.executeUpdate();
		customerConn.setAutoCommit(true);
	}
}