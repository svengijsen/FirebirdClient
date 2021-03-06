//FirebirdClient
//Copyright (C) 2015  Sven Gijsen
//
//This file is part of BrainStim.
//BrainStim is free software: you can redistribute it and/or modify
//it under the terms of the GNU General Public License as published by
//the Free Software Foundation, either version 3 of the License, or
//(at your option) any later version.
//
//This program is distributed in the hope that it will be useful,
//but WITHOUT ANY WARRANTY; without even the implied warranty of
//MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//GNU General Public License for more details.
//
//You should have received a copy of the GNU General Public License
//along with this program.  If not, see <http://www.gnu.org/licenses/>.
//


#include "firebirdclientplugin.h"
#include "firebirdclient.h"
#include "defines.h"

Q_DECLARE_METATYPE(FirebirdClient*)
Q_DECLARE_METATYPE(FirebirdClient)

FirebirdClientPlugin::FirebirdClientPlugin(QObject *parent)
{
	FirebirdClientObject = new FirebirdClient(parent);
	FirebirdClientDiagObject = new FirebirdClient_Dialog();	
	strPluginInformation = QString(PLUGIN_INTERNAL_NAME) + " Plugin" + "(v" + PLUGIN_FILE_VERSION_STRING + ")";// +" by " + PLUGIN_AUTHOR_NAME;
	strPluginInternalName = PLUGIN_INTERNAL_NAME;
}

FirebirdClientPlugin::~FirebirdClientPlugin()
{
	if (FirebirdClientDiagObject)
	{
		delete FirebirdClientDiagObject;
		FirebirdClientDiagObject = NULL;
	}
	if (FirebirdClientObject)
	{
		delete FirebirdClientObject;
		FirebirdClientObject = NULL;
	}
	
}

int FirebirdClientPlugin::ConfigureScriptEngine(QScriptEngine &engine)
{
	QScriptValue FirebirdClientProto = engine.newQObject(FirebirdClientObject);
	engine.setDefaultPrototype(qMetaTypeId<FirebirdClient*>(), FirebirdClientProto);
	QScriptValue FirebirdClientCtor = engine.newFunction(FirebirdClient::ctor_FirebirdClient, FirebirdClientProto);
	engine.globalObject().setProperty(PLUGIN_SCRIPTOBJECT_NAME, FirebirdClientCtor);
	int nMetaType = qRegisterMetaType<FirebirdClient>(PLUGIN_SCRIPTOBJECT_CLASS);
	//FinalizeScriptObjectScriptContext(engine, FirebirdClientObject);
	return nMetaType;
}

bool FirebirdClientPlugin::ShowGUI()
{
	int returnVal;
	FirebirdClientDiagObject->setWindowTitle(strPluginInformation);
	returnVal = FirebirdClientDiagObject->exec();

	switch (returnVal) {
	case QMessageBox::Save:
	   // Save was clicked
	   break;
	case QMessageBox::Discard:
		// Don't Save was clicked
	    break;
	case QMessageBox::Cancel:
	    // Cancel was clicked
	    break;
	default:
	    // should never be reached
	    break;
	}		
	return true;
}

