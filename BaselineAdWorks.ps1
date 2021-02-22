$ProjectFolder = 'MyPathTo\FlywayAndAdworks' #your project folder
$Server = 'MyServer' #the name or instance of SQL Server
$Database = 'Adworks'; #The name of the development database that you are using
$Password = 'SecretPassword' #your password (leave blank if you use windows security)
$UserID = 'MyUid' # your userid (leave blank if you use windows security)
$port = '1433' # the port that the service is on

if ($userID -eq '')
 {
 $FlyWayArgs=
    @("-url=jdbc:sqlserver://$($Server):$port;databaseName=$Database;integratedSecurity=true"; <# provide server and password  #>
      "-locations=filesystem:$ProjectFolder\Scripts")<# the migration folder #>
      }
else
{<# just to make things easier to see and document, we'll splat the parameters to FlyWay
via a hashtable, but it could just as easily be do as a conventional command line#>
$FlyWayArgs=
    @("-user=$UserID"; <# you only need this and password if there is no domain authentication #>
      "-password=$Password"; <# Normally, you'd have a routine to provide this dynamically #>
      "-url=jdbc:sqlserver://$($Server):$port;databaseName=$Database"; <# provide server and password  #>
      "-locations=filesystem:$ProjectFolder\Scripts")<# the migration folder #>
}


Flyway migrate @FlywayArgs -mixed=true  # get to whatever level you want
flyway info @FlywayArgs 


# We try it on AdventureWorks2016 (our pretend production server) by changing the value in $database  and running …
flyway info @FlywayArgs 
Flyway baseline  @FlywayArgs -baselineVersion='1.3.1' -baselineDescription='Existing version of Adventureworks' 