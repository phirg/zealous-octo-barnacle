#include <iostream>

// Poco
#include "Poco/Util/Application.h"
#include "Poco/Util/Option.h"
#include "Poco/Util/OptionSet.h"
#include "Poco/Util/HelpFormatter.h"
#include "Poco/Util/AbstractConfiguration.h"

#include "Poco/Version.h" // FIXME to be included only for version >= 1.4.0
#include "Poco/NumberFormatter.h"

using Poco::Util::Application;
using Poco::Util::Option;
using Poco::Util::OptionSet;
using Poco::Util::HelpFormatter;
using Poco::Util::OptionCallback;
using Poco::Util::AbstractConfiguration;
using Poco::Message; // PRIO_TRACE

/**
 * CoreApp
 *
 * This class is the nutshell of all of the core application.
 * It uses some of the features of the Util::Application class,
 * such as command line arguments processing.
 *
 * Try hello --help (on Unix platforms) or instrumentall /help (elsewhere) for
 * more information.
 */
class CoreApp: public Application
{
public:
    CoreApp(): _helpRequested(false)
    /// default constructor
    {
        // Application::instance().addSubsystem(new MySubsystem); //template

    }

protected:
    void initialize(Application& self)
    /// Initializes the application and all registered subsystems.
    /// Subsystems are always initialized in the exact same order
    /// in which they have been registered.
    ///
    /// Must call the base class implementation.
    {
        // hack:
        // I tried to overload run() to prevent the initialization
        // in case of help requested, but it was not sufficient.
        // something else initializes the subsystems before run()
        // see also: main()
        if (_helpRequested)
            return;

        // load std config file
        if (0==loadConfiguration())
        {
            poco_notice(logger(), "No standard configuration file found");
        }

        Application::initialize(self);
    }

    void uninitialize()
    /// Uninitializes the application and all registered subsystems.
    /// Subsystems are always uninitialized in reverse order in which
    /// they have been initialized.
    ///
    /// Must call the base class implementation.
    {
        // uninitialization code comes here
        Application::uninitialize();
    }

    void reinitialize(Application& self)
    /// Re-initializes the application and all registered subsystems.
    /// Subsystems are always reinitialized in the exact same order
    /// in which they have been registered.
    ///
    /// Must call the base class implementation.
    {
        Application::reinitialize(self);
        // reinitialization code comes here
    }

    void defineOptions(OptionSet& options)
    /// Called before command line processing begins.
    /// Used to support command line arguments.
    ///
    /// Call defineOptions() on all registered subsystems.
    ///
    /// Should call the base class implementation.
    {
        Application::defineOptions(options); // subsystems defineOptions( )

        options.addOption(
            Option("help", "h", "display help information on command line arguments")
                .required(false)
                .repeatable(false)
                .callback(OptionCallback<CoreApp>(this, &CoreApp::handleHelp)));

        options.addOption(
            Option("config-file", "f", "load configuration data from FILE")
                .required(false)
                .repeatable(true)
                .argument("FILE")
                .callback(OptionCallback<CoreApp>(this, &CoreApp::handleConfig)));
    }

    void handleHelp(const std::string& name, const std::string& value)
    /// callback function to handle the use of 'h' or 'help' command line option
    {
        _helpRequested = true;
        displayHelp();
        stopOptionsProcessing(); // if other callbacks were already launched, it is too late...
    }

    void handleConfig(const std::string& name, const std::string& value)
    /// handle custom config file at a non-standard path
    {
        loadConfiguration(value);
    }

    std::string version()
    {
        return "0.1";
    }
    
    std::string pocoVersion()
    {
        std::string pocoV;
        int patch = (POCO_VERSION >> 8) & 0xFF;
        int minor = (POCO_VERSION >> 16) & 0xFF;
        int major = (POCO_VERSION >> 24) & 0xFF;
        
        pocoV = Poco::NumberFormatter::format(major) + "."
              + Poco::NumberFormatter::format(minor) + "."
              + Poco::NumberFormatter::format(patch) ;
              
        switch (POCO_VERSION & 0xF0)
        {
        case 0xA0:
            pocoV = pocoV + "(alpha" + Poco::NumberFormatter::format(POCO_VERSION & 0x0F) + ")";
            break;
        case 0xB0:
            pocoV = pocoV + "(beta" + Poco::NumberFormatter::format(POCO_VERSION & 0x0F) + ")";
            break;
        case 0xD0:
            pocoV = pocoV + "(dev" + Poco::NumberFormatter::format(POCO_VERSION & 0x0F) + ")";
            break;
        case 0x00:
            if ((POCO_VERSION & 0x0F) == 0 )
                pocoV = pocoV + "(stable)";
            // else: unknown
            break;
        default:
            // unknown
            break;
        }
        
        return pocoV;
    }

    void displayHelp()
    /// display the help message requested by the option 'help' (short: 'h')
    /// using the HelpFormatter class.
    {
        HelpFormatter helpFormatter(options());
        helpFormatter.setCommand(commandName());
        helpFormatter.setUsage("[options]");
        helpFormatter.setHeader(
            "Hello version " + version() + " - test application");
        helpFormatter.format(std::cout);
    }

    std::string about()
    /// display various infos -- including dependencies version
    {
        return std::string("Hello version ") + version() + " - test application\n"
            "Copyright (c) 2013-2015, Opticalp.fr and contributors\n"
            "MIT License, see http://www.opensource.org/licenses/MIT\n\n" 
            "Proudly using: \n"
            " - "
            "Poco libraries (" 
            + pocoVersion() 
            + ") http://pocoproject.org, SPDX-License-Identifier: BSL-1.0 license" ;
    }
    
    void displayAbout()
    {
        std::cout << about() << std::endl;        
    }


    int main(const std::vector<std::string>& args)
    /// The application's main logic.
    /// Unprocessed command line arguments are passed in args.
    {
        if (_helpRequested)
            return Application::EXIT_OK;

        logger().information("Arguments to main():");
        for (std::vector<std::string>::const_iterator it = args.begin(); it != args.end(); ++it)
        {
            logger().information(*it);
        }
        logger().information("Application properties:");
        printProperties("");

        logger().information(about());
        
        return Application::EXIT_OK;
    }

    void printProperties(const std::string& base)
    /// recursive display of all the application properties
    {
        AbstractConfiguration::Keys keys;
        config().keys(base, keys);
        if (keys.empty()) // key has no child
        {
            if (config().hasProperty(base))
            {
                std::string msg;
                msg.append(base);
                msg.append(" = ");
                msg.append(config().getString(base));
                poco_information(logger(),msg);
            }
        }
        else // recursion
        {
            for (AbstractConfiguration::Keys::const_iterator it = keys.begin(); it != keys.end(); ++it)
            {
                std::string fullKey = base;
                if (!fullKey.empty()) fullKey += '.';
                fullKey.append(*it);
                printProperties(fullKey);
            }
        }
    }

private:
    bool _helpRequested;
};


POCO_APP_MAIN(CoreApp)
