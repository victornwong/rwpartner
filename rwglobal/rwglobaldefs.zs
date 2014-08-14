import groovy.sql.Sql;
import org.zkoss.zk.ui.*;

/*
Global vars and defs for Rentwise Sdn Bhd -- KNOCKOFF from rws, sync accordingly
*/

// HARDCODED for now -- TODO move into lookup for easier modi
SYS_SMTPSERVER = "192.168.100.15";
SYS_EMAIL = "notification@rentwise.com";
SYS_EMAILUSER = "notification";
SYS_EMAILPWD = "rent2000wise";

BOM_PREFIX = "BOM";
TICKETSV_PREFIX = "CSV";
PARTS_PREFIX = "PRT";
OSDO_PREFIX = "PDO";

CASEOPEN_STR = "OPEN";
CASECLOSE_STR = "CLOSE";
CASECANCEL_STR = "CANCEL";

LOCALRMA_PREFIX = "LRMA";
NORMAL_BACKGROUND = "background:#2e3436;";
CRITICAL_BACKGROUND = "background:#ef2929;";
URGENT_BACKGROUND = "background:#fcaf3e;";

TEMPFILEFOLDER = "tmp/";

mainPlayground = "//als_portal_login/";

// stuff transfered to GlobalDefs.java
DOCUMENTSTORAGE_DATABASE = "DocumentStorage";

MAINLOGIN_PAGE = "index.zul";
VERSION = "0.04.15d-vw";
SMTP_SERVER = "";
ELABMAN_EMAIL = "";

MAINPROCPATH = ".";

// GUI types
GUI_PANEL = 1;
GUI_WINDOW = 2;
GUI_REPORT = 3;

public class modulesObj
{
	public int module_num;
	public String module_name;
	public int accesslevel;
	
	public int module_gui;
	public String module_fn;
	public int modal_flag;
	public String parameters;
	
	public modulesObj(int imodule_num, String imodule_name, int iaccesslevel, int iguitype, String imodule_fn, int imodal_flag, String iparam)
	{
		module_num = imodule_num;
		module_name = imodule_name;
		accesslevel = iaccesslevel;
		module_gui = iguitype;
		module_fn = imodule_fn;
		modal_flag = imodal_flag;
		parameters = iparam;
	}
}


