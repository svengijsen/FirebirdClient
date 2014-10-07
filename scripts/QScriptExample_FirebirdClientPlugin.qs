//Construct a new Plugin object
var FirebirdClientobject = new FirebirdClient();
var scriptRootPath = BrainStim.getActiveDocumentFileLocation();
var sTimeStamp = getTimeStamp() ;
var databaseName = sTimeStamp + ".FDB";
var databasePath = scriptRootPath + "/" + databaseName;
var excelFileName = sTimeStamp + ".xls";
var excelExportPath = scriptRootPath + "/" + excelFileName;
var userName = "user";
var userPassword = "123";
var bResult = true;
var QueryCreateTable = 
	"create table people (" + 
	"id int not null," + 
	"nickname varchar(12) not null," + 
	"country char(4)," + 
	"constraint pk_people primary key (id)," + 
	"constraint uk_nickname unique (nickname) using index ix_nick" + 
	")";
var QueryInsertRecord1 =	
"insert into people (id, nickname, country) " +
"values ('1', 'Nick_Name_one', 'NLE') " +
"returning nickname";
var QueryInsertRecord2 =	
"insert into people (id, nickname, country) " +
"values ('0', 'Nick_Name_two', 'FR') " +
"returning nickname";
var QueryInsertRecord3 =	
"insert into people (id, nickname, country) " +
"values ('2', 'Nick_Name_three', 'RS') " +
"returning nickname";
var QuerySelectRecords = 
"select * from people"
var QueryCreateProcedure = 
"CREATE PROCEDURE ADD_INTS (" +
" A      INTEGER," +
" B      INTEGER)" +
" RETURNS (" +
" RESULT INTEGER)" +
" AS " +
" begin" +
" RESULT = A + B;" +
" end";
var QueryCallProcedure = "EXECUTE PROCEDURE ADD_INTS(53, 4)";

function getTimeStamp() 
{
	var now = new Date();
	return (String(now.getFullYear()) +
		String(now.getMonth() + 1) +
		String(now.getDate()) +
		String(now.getHours()) +
		((now.getMinutes() < 10)? String("0" + now.getMinutes()): String(now.getMinutes())) +
		((now.getSeconds() < 10)? String("0" + now.getSeconds()) : String(now.getSeconds())));
}

Log("\n");

var fDatabase = new QFile(databasePath);
if(fDatabase.exists())
	fDatabase.remove();
if(fDatabase.exists() == false)
{
	bResult = FirebirdClientobject.CreateDatabase(databasePath,userName,userPassword);
	Log("CreateDatabase() returned: " + bResult);
}
else
{
	Log("Database already present and cannot delete.. exiting");
	bResult = false;
}
if(bResult)
{
	bResult = bResult && FirebirdClientobject.OpenDatabase(databasePath,userName,userPassword)
	Log("OpenDatabase() returned: " + bResult);
	if(bResult)
	{
		//bResult = bResult && FirebirdClientobject.InitializeDatabase()
		//Log("InitializeDatabase() returned: " + bResult);	
		bResult = bResult && FirebirdClientobject.ExecuteDatabaseQuery(QueryCreateTable)
		Log("ExecuteDatabaseQuery(QueryCreateTable) returned: " + bResult);
		bResult = bResult && FirebirdClientobject.ExecuteDatabaseQuery(QueryInsertRecord1)
		Log("ExecuteDatabaseQuery(QueryInsertRecord1) returned: " + bResult);	
		bResult = bResult && FirebirdClientobject.ExecuteDatabaseQuery(QueryInsertRecord2)
		Log("ExecuteDatabaseQuery(QueryInsertRecord2) returned: " + bResult);	
		bResult = bResult && FirebirdClientobject.ExecuteDatabaseQuery(QueryInsertRecord3)
		Log("ExecuteDatabaseQuery(QueryInsertRecord3) returned: " + bResult);	
		bResult = bResult && FirebirdClientobject.ExecuteDatabaseQuery(QuerySelectRecords)
		Log("ExecuteDatabaseQuery(QuerySelectRecords) returned: " + bResult);	
		bResult = bResult && FirebirdClientobject.ExecuteDatabaseQuery(QueryCreateProcedure)
		Log("ExecuteDatabaseQuery(QueryCreateProcedure) returned: " + bResult);		
		bResult = bResult && FirebirdClientobject.ExecuteDatabaseQuery(QueryCallProcedure)
		Log("ExecuteDatabaseQuery(QueryCallProcedure) returned: " + bResult);
		Log("ExecuteDatabaseQuery(QuerySelectRecords) returned: " + FirebirdClientobject.ExecuteReturnDatabaseQuery(QuerySelectRecords, "nickname"));
		bResult = bResult && FirebirdClientobject.ExportDatabasetoExcel(excelExportPath,QuerySelectRecords);
		Log("ExportDatabasetoExcel(QuerySelectRecords) returned: " + bResult);
		bResult = bResult && FirebirdClientobject.CloseDatabase()
		Log("CloseDatabase() returned: " + bResult);	
	}	
}


Log("\n");
//Set the constructed objects and function to null
getTimeStamp = null;
FirebirdClientobject = null;