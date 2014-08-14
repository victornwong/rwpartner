import org.zkoss.util.media.*;

// 19/08/2013: mod for rentwise/partners portal
//---- docu/attachments uploading funcs

selected_file_id = ""; // global for attach-docu origid

// onSelect for filleDocumentsList()
class doculinks_lb_onSelect implements org.zkoss.zk.ui.event.EventListener
{
	public void onEvent(Event event) throws UiException
	{
		selitem = event.getReference();
		selected_file_id = lbhand.getListcellItemLabel(selitem,0);
		updatefiledesc_label.setLabel(lbhand.getListcellItemLabel(selitem,1));
		update_file_description.setValue(lbhand.getListcellItemLabel(selitem,2));
	}
}

void fillDocumentsList(Div idiv, String iprefix, String iorigid)
{
	Object[] documentLinks_lb_headers = {
	new dblb_HeaderObj("origid",false,"origid",2),
	new dblb_HeaderObj("File",true,"file_title",1),
	new dblb_HeaderObj("Description",true,"file_description",1),
	new dblb_HeaderObj("D.Created",true,"datecreated",3),
	new dblb_HeaderObj("Owner",true,"username",1),
	};

	// always remove prev doc-LB if any
	if(idiv.getFellowIfAny("doculinks_lb") != null) doculinks_lb.setParent(null);

	selected_file_id = ""; // reset
	duclink = iprefix + iorigid;

	ds_sql = sqlhand.DMS_Sql();
	if(ds_sql == null) return;
	
	incdel = " and deleted=0";
	/*
	if(useraccessobj.accesslevel == 9) // admin can see everything..
		incdel = "";
	*/
	sqlstm = "select origid,file_title,file_description,datecreated,username from DocumentTable " +
	"where docu_link='" + duclink + "'" + incdel;
	
	Listbox newlb = lbhand.makeVWListbox_onDB(idiv,documentLinks_lb_headers,"doculinks_lb",5,ds_sql,sqlstm);
	//newlb.setMultiple(true);
	newlb.setMold("paging");
	newlb.addEventListener("onSelect", new doculinks_lb_onSelect());
	ds_sql.close();
	//if(newlb.getItemCount() > 5) newlb.setRows(10);
}

void uploadFile(Div idiv, String iprefix, String idocudx, Media[] media)
{
	if(idocudx.equals("")) return;
	doculink_str = iprefix + idocudx;
	docustatus_str = "ACTIVE";
	ftitle = kiboo.replaceSingleQuotes(fileupl_file_title.getValue());
	fdesc = kiboo.replaceSingleQuotes(fileupl_file_description.getValue());
	if(ftitle.equals(""))
	{
		guihand.showMessageBox("Please enter a filename..");
		return;
	}

	ospname = os_useraccessobj.ar_code + " " + os_useraccessobj.username;
	dmshand.uploadFile(ospname, os_useraccessobj.ar_code, kiboo.todayISODateString(),
		doculink_str,docustatus_str,ftitle,fdesc, media); // dmsfuncs.zs

	fillDocumentsList(idiv,iprefix,idocudx);
	uploadfile_popup.close();
}

void showUploadPopup(String iprefix, String idocudx)
{
	if(idocudx.equals("")) return;
	uploadfile_popup.open(uploaddoc_btn);
}

// TODO hardcoded pin to view file from partner portal
void authorize_viewFile(Div idiv, String ipin)
{
	authorizeviewfile_pop.close(); // def in caller-modu UI
	if(selected_file_id.equals("")) return;
	if(ipin.equals("1200")) viewFile(idiv);
}

// Modd to not use guihand.globalActivateWindow()
void viewFile(Div idiv)
{
	if(selected_file_id.equals("")) return;
	theparam = "docid=" + selected_file_id;
	uniqid = kiboo.makeRandomId("v");
	//guihand.globalActivateWindow(mainPlayground,"miscwindows","documents/viewfile.zul", uniqid, theparam, os_useraccessobj);

	Include newinclude = new Include();
	newinclude.setId(uniqid);
	String includepath = "documents/viewfile.zul" + "?myid=" + uniqid + "&" + theparam;
	newinclude.setSrc(includepath);
	sechand.itest_setUserAccessObj(newinclude, os_useraccessobj); // securityfuncs.zs
	newinclude.setParent(idiv);
}

void deleteFile(Div idiv, String iprefix, String idocudx)
{
	if(selected_file_id.equals("")) return;
	if(os_useraccessobj.accesslevel < 9) { guihand.showMessageBox("Only admin can do hard-delete"); return; }

	if (Messagebox.show("This is a hard-delete..", "Are you sure?", 
		Messagebox.YES | Messagebox.NO, Messagebox.QUESTION) !=  Messagebox.YES) return;

	sqlstm = "delete from DocumentTable where origid=" + selected_file_id;
	dmshand.dmsgpSqlExecuter(sqlstm);
	fillDocumentsList(idiv,iprefix,idocudx); // refresh
}

void updateFileDescription(Div idiv, String iprefix, String idocudx)
{
	fdesc = kiboo.replaceSingleQuotes(update_file_description.getValue());
	sqlstm = "update DocumentTable set file_description='" + fdesc + "' where origid=" + selected_file_id;
	dmshand.dmsgpSqlExecuter(sqlstm);
	fillDocumentsList(idiv,iprefix,idocudx); // refresh
	updatefiledesc_popup.close();
}


