#User Management#

If you have seen some of the MaaSive competitors, you may have noticed that most of them have pre-made user objects for you to use in your applications.  While we understand the importance of having user objects, we chose not to limit you to a predefined model.  Instead, we are going to walk you through creating your own simple user object using the MaaSive framework.  You are then able to further extend this object adding additional properties and methods as you please.

This tutorial will assume that you have a basic project in place configured to use the MaaSive framework.  If you don't know how to do this, please follow [these instructions](http://www.maasiveapi.com/documentation/getting-started-ios).

#### Creating The Model ####

Start by creating a new MaaSModel subclass called User and add any properties you want associated with them.  Here is our sample header file for our User class with some useful properties.

    #import <Maasive/MaaSive.h>

	@interface User : MaaSModel {
	    NSString *_username;
	    NSString *_email;
	    NSString *_realName;
	    MaaSEncryptedString *_password;
	}

	@property(nonatomic, retain) NSString *username;
	@property(nonatomic, retain) NSString *email;
	@property(nonatomic, retain) NSString *realName;
	@property(nonatomic, retain) MaaSEncryptedString *password;

	@end

Remember, that by extending MaaSModel, your class automatically gets the **\_id**, **created\_at**, and **updated\_at** properties as well.  Also, by declaring password as a MaaSiveEncryptedString, the server will never store the user's password in plain text.  One thing to note about MaaSEncryptedStrings is that they use one way encryption and should only be used for validation.  For example, you could not use them to store user credit card information.

The User.m file should now look something like this:

    #import "User.h"

	@implementation User

	@synthesize username = _username;
	@synthesize email = _email;
	@synthesize realName = _realName;
	@synthesize password = _password;

	- (void) dealloc {
	    [_username release];
	    [_email release];
	    [_realName release];
	    [_password release];
	    [super dealloc];
	}

	@end
	
You now have a fully featured User model to work with in your applications.  Here are a few code snippets of common user functions.  For demonstration purposes, we are only going to show these functions using the synchronous approach, however the same design patterns can be used with the callbacks and blocks approach as well.

#### Create A New User ####

The process to create a user is quite straight forward.  Simply, init a new user object, set up its properties, and call saveRemote:error:.  Once the save completes, the user object will now have it's \_id, created\_at, and update\_at properties set from the server.  The \_id field is important as you will use that to uniquely identify the user going forward.

    User *user = [[User alloc] init];
    user.username = @"newUser";
    user.password = (MaaSEncryptedString *)@"newPassword";
    NSError *error = nil;
    [user saveRemote:&error]; 

#### Checking If A User Exists By Username ####

There are a couple ways that we can check for the existence of a user.  You could either use the findRemoteWithQuery:error: method which will return a single member array containing the User object or you could use the findRemoteCountWithQuery:error: method, which will return the number of users matching the query.  The method you choose is up to you depending on your application needs.  For this example, we are using the findRemoteWithQuery:error: method, so that we have the user on hand to update them if they _do_ exist.

    NSError *error = nil;
    NSDictionary *query = [NSDictionary dictionaryWithObject:@"newUser" 
                           forKey:@"username.eql"];
    NSArray *users = [User findRemoteWithQuery:query error:&error];
    // To check if the user exists
    BOOL exists = [users count] > 0;

Similarly, we can add the password field to _"log a user in"_ by modifying the query to look like this.

    NSDictionary *query = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"newUser",@"username.eql",
                           @"newPassword",@"password.eql", nil];

More information on the query language for MaaSive can be found [here](http://www.maasiveapi.com/Documentation/iOS/interface_maa_s_model.html#a6c26a65f81ceb8f5ac512ef7c97954e2).

#### Updating An Existing User ####

In order to update an existing user, you will need to have a user on hand.  To do this, you must either have called one of the findRemote methods which return users OR have retrieved a saved User object from disk.  The MaaSive framework will use the \_id property of the user to uniquely identify them.  Going off the example above, let's say that the users array contains a single user object.  You would then update and save them like this.

    User *user = [users objectAtIndex:0];
    user.email = @"newUser@maaSive.com";
    NSError *error = nil;
    [user saveRemote:&error];

#### Deleting A User ####

Just like when we updated a user, we must have a User object on hand when deleting one from the web.  Again, assume that the users array above contains a single User object. To delete this user from the web, we would call the removeRemote:error: method like so.

	NSError *error = nil;
    [user removeRemote:&error];



