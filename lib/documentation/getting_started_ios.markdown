# Getting Started #

Welcome to MaaSive!  Here are some simple steps to get you up and running.  

## Create An Application On The Web ##

Start by going to [this page](http://www.maasiveapi.com/apps/new) and creating a new application. This will generate an application id and secret key for you to use in the coming steps.

![Create A New Application](http://f.cl.ly/items/3t0q1I053m251f1C3f1v/Screen%20shot%202011-06-23%20at%201.53.59%20PM.png)

## Download The Installer ##

The MaaSive framework has a few external dependancies on various frameworks in order to function.  Rather than adding all of these dependancies manually, we have created an installer to do this for you.

Start by [downloading the installer](http://dl.dropbox.com/u/1574088/elc/MaaSive/Installer/MaaSiveInstaller.zip)

After launching, tap the **Choose...** button and navigate to your project folder.  Then select the **.xcodeproj** file.

![Select the .xcodeproj file](http://f.cl.ly/items/2r0s2H1a3K3C0N173R3Q/Screen%20shot%202011-06-15%20at%201.56.50%20PM.png)

Once selected, tap **Setup** and your project will configured for MaaSive.  You _should_ see the following frameworks added in.

* **MaaSive.framework**
* CFNetwork.framework
* SystemConfiguration.framework
* Security.framework
* MobileCoreServices.framework
* libz.1.2.3.dylib

In addition to adding the frameworks, your project _should_ also contain the **-ObjC** linker flag.

## Setting Up Your Keys ##

Once you create an application on the web, you are given an **application id** and an **application secret**.  To configure your application to use these parameters, add the following code to your application's delegate.

    // Import the MaaSManager
    #import <MaaSive/MaaSive.h>

At the beginning of your application:didFinishLaunchingWithOptions method...

    MaaSManager *manager = [MaaSManager sharedManager];
    manager.appId = @"<Your app id>";
    manager.secretKey = @"<Your app secret>";

## Create A Model ##

Creating a MaaSive Model is as easy as making a new class that extends **MaaSModel**.  Once you extend **MaaSModel**, any properties you add to your class will automatically be added to your web interface.

One thing to note is, MaaSive *requires* that you create properties for all of your iVars and synthesize them.

Say for example we have a class called Task that contains 2 properties: completed and name...

**Task.h**

    #import <MaaSive/MaaSive.h>

    @interface Task : MaaSModel {
        BOOL _completed;
        NSString *_name;
    }
    @property(nonatomic) BOOL completed;
    @property(nonatomic, retain) NSString *name;

    @end

**Task.m**
    #import "Task.h"

    @implementation ListItem

    @synthesize completed = _completed;    
    @synthesize name = _name;

    - (void) dealloc {
        [_name release];
        [super dealloc];
    }

    @end

That's it! There are no special hooks or methods that are required.  

## Saving Your Model To The Web ##

If you want to save your Model to the web, you have many different options.  The easiest is to use the synchronous saveRemote method.

    Task *task = [[Task alloc] init];
    task.name = @"Get Milk";
    NSError *error = nil;
    [task saveRemote:&error];
    [task release];

For more information, check out the [SDK Documentation](http://www.maasiveapi.com/documentation/ios-documentation).