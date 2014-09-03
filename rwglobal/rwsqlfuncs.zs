import java.lang.Float;
import groovy.sql.Sql;
import org.zkoss.zk.ui.*;
import org.zkoss.zk.zutl.*;

// 10/07/2013: moved 'em sql-related funcs here TODO byte-compile later

// Merge 2 object-arrays into 1 - codes copied from some website
Object[] mergeArray(Object[] lst1, Object[] lst2)
{
	List list = new ArrayList(Arrays.asList(lst1));
	list.addAll(Arrays.asList(lst2));
	Object[] c = list.toArray();
	return c;
}

void popuListitems_Data(ArrayList ikb, String[] ifl, Object ir)
{
	for(i=0; i<ifl.length; i++)
	{
		try {
		kk = ir.get(ifl[i]);
		if(kk == null) kk = "";
		else
			if(kk instanceof Date) kk = dtf2.format(kk);
		else
			if(kk instanceof Integer) kk = nf0.format(kk);
		else
			if(kk instanceof BigDecimal)
			{
				rt = kk.remainder(BigDecimal.ONE);
				if(rt.floatValue() != 0.0)
					kk = nf2.format(kk);
				else
					kk = nf0.format(kk);
			}
		else
			if(kk instanceof Double) kk = nf2.format(kk);
		else
			if(kk instanceof Float) kk = kk.toString();
		else
			if(kk instanceof Boolean) { wi = (kk) ? "Y" : "N"; kk = wi; }

		ikb.add( kk );
		} catch (Exception e) {}
	}
}

void blindTings(Object iwhat, Object icomp)
{
	itype = iwhat.getId();
	klk = iwhat.getLabel();
	bld = (klk.equals("+")) ? true : false;
	iwhat.setLabel( (klk.equals("-")) ? "+" : "-" );
	icomp.setVisible(bld);
}

void blindTings_withTitle(Object iwhat, Object icomp, Object itlabel)
{
	itype = iwhat.getId();
	klk = iwhat.getLabel();
	bld = (klk.equals("+")) ? true : false;
	iwhat.setLabel( (klk.equals("-")) ? "+" : "-" );
	icomp.setVisible(bld);

	itlabel.setVisible((bld == false) ? true : false );
}

void downloadFile(Div ioutdiv, String ifilename, String irealfn)
{
	File f = new File(irealfn);
	fileleng = f.length();
	finstream = new FileInputStream(f);
	byte[] fbytes = new byte[fileleng];
	finstream.read(fbytes,0,(int)fileleng);

	AMedia amedia = new AMedia(ifilename, "xls", "application/vnd.ms-excel", fbytes);
	Iframe newiframe = new Iframe();
	newiframe.setParent(ioutdiv);
	newiframe.setContent(amedia);
}

void activateModule(String iplayg, String parentdiv_name, String winfn, String windId, String uParams, Object uAO)
{
	Include newinclude = new Include();
	newinclude.setId(windId);

	includepath = winfn + "?myid=" + windId + "&" + uParams;
	newinclude.setSrc(includepath);

	sechand.setUserAccessObj(newinclude, uAO); // securityfuncs.zs

	Div contdiv = Path.getComponent(iplayg + parentdiv_name);
	newinclude.setParent(contdiv);

} // activateModule()

// Use to refresh 'em checkboxes labels -- can be used for other mods
// iprefix: checkbox id prefix, inextcount: next id count
void refreshCheckbox_CountLabel(String iprefix, int inextcount)
{
	count = 1;
	for(i=1;i<inextcount; i++)
	{
		bci = iprefix + i.toString();
		icb = items_grid.getFellowIfAny(bci);
		if(icb != null)
		{
			icb.setLabel(count + ".");
			count++;
		}
	}
}

// itype: 1=width, 2=height
gpMakeSeparator(int itype, String ival, Object iparent)
{
	sep = new Separator();
	if(itype == 1) sep.setWidth(ival);
	if(itype == 2) sep.setHeight(ival);
	sep.setParent(iparent);
}

org.zkoss.zul.Textbox gpMakeTextbox(Object iparent, String iid, String ivalue, String istyle, String iwidth)
{
	org.zkoss.zul.Textbox retv = new org.zkoss.zul.Textbox();
	if(!iid.equals("")) retv.setId(iid);
	if(!istyle.equals("")) retv.setStyle(istyle);
	if(!ivalue.equals("")) retv.setValue(ivalue);
	if(!iwidth.equals("")) retv.setWidth(iwidth);
	retv.setParent(iparent);
	return retv;
}

Button gpMakeButton(Object iparent, String iid, String ilabel, String istyle, Object iclick)
{
	Button retv = new Button();
	if(!istyle.equals("")) retv.setStyle(istyle);
	if(!ilabel.equals("")) retv.setLabel(ilabel);
	if(!iid.equals("")) retv.setId(iid);
	if(iclick != null) retv.addEventListener("onClick", iclick);
	retv.setParent(iparent);
	return retv;
}

Label gpMakeLabel(Object iparent, String iid, String ivalue, String istyle)
{
	Label retv = new Label();
	if(!iid.equals("")) retv.setId(iid);
	if(!istyle.equals("")) retv.setStyle(istyle);
	retv.setValue(ivalue);
	retv.setParent(iparent);
	return retv;
}

Checkbox gpMakeCheckbox(Object iparent, String iid, String ilabel, String istyle)
{
	Checkbox retv = new Checkbox();
	if(!iid.equals("")) retv.setId(iid);
	if(!istyle.equals("")) retv.setStyle(istyle);
	if(!ilabel.equals("")) retv.setLabel(ilabel);
	retv.setParent(iparent);
	return retv;
}

// Add something to rw_systemaudit, datecreated will have time too
// ilinkc=linking_code, isubc=linking_sub, iwhat=audit_notes
void add_RWAuditLog(String ilinkc, String isubc, String iwhat, String iuser)
{
	todaydate =  kiboo.todayISODateTimeString();
	sqlstm = "insert into rw_systemaudit (datecreated,linking_code,linking_sub,audit_notes,username) values " +
	"('" + todaydate + "','" + ilinkc + "','" + isubc + "','" + iwhat + "','" + iuser + "')";
	sqlhand.gpSqlExecuter(sqlstm);
}

Object getStockItem_rec(String istkcode)
{
	sqlstm = "select * from stockmasterdetails where stock_code='" + istkcode + "'";
	return sqlhand.gpSqlFirstRow(sqlstm);
}

boolean checkStockExist(String istkc)
{
	sqlstm = "select id from stockmasterdetails where stock_code='" + istkc + "'";
	krr = sqlhand.gpSqlFirstRow(sqlstm);
	retval = false;
	if(krr != null) retval = true;
	return retval;
}

Object getPartsReq_rec(String iwhat)
{
	sqlstm = "select * from rw_partner_partsreq where origid=" + iwhat;
	return sqlhand.gpSqlFirstRow(sqlstm);
}

Object getFocus_CustomerRec(String icustid)
{
	focsql = sqlhand.rws_Sql();
	if(focsql == null) return null;
	sqlstm = "select cust.name,cust.code,cust.code2, " +
	"custd.address1yh, custd.address2yh, custd.address3yh, custd.address4yh, " +
	"custd.telyh, custd.faxyh, custd.contactyh, custd.deliverytoyh, " +
	"custd.salesrepyh,custd.interestayh,custd.emailyh from mr000 cust " +
	"left join u0000 custd on custd.extraid = cust.masterid " +
	"where cust.type=195 and cust.masterid=" + icustid;
	retval = focsql.firstRow(sqlstm);
	focsql.close();
	return retval;
}

String getFocus_CustomerName(String icustid)
{
	focsql = sqlhand.rws_Sql();
	if(focsql == null) return "NEW";
	sqlstm = "select cust.name from mr000 cust where cust.type=195 and cust.masterid=" + icustid;
	retval = focsql.firstRow(sqlstm);
	focsql.close();
	if(retval == null) return "NEW";
	return retval.get("name");
}

Object getHelpTicket_rec(String iwhat)
{
	sqlstm = "select * from rw_helptickets where origid=" + iwhat;
	return sqlhand.gpSqlFirstRow(sqlstm);
}

Object getLocalRMA_rec(String iwhat)
{
	sqlstm = "select * from rw_localrma where origid=" + iwhat;
	return sqlhand.gpSqlFirstRow(sqlstm);
}

Object getLocalRMAItem_rec(String iwhat)
{
	sqlstm = "select * from rw_localrma_items where origid=" + iwhat;
	return sqlhand.gpSqlFirstRow(sqlstm);
}

Object getLC_rec(String iwhat)
{
	sqlstm = "select * from rw_leasingcontract where origid=" + iwhat;
	return sqlhand.gpSqlFirstRow(sqlstm);
}

Object getLCAsset_rec(String iwhat)
{
	sqlstm = "select * from rw_leaseequipments where origid=" + iwhat;
	return sqlhand.gpSqlFirstRow(sqlstm);
}

Object getRentalItems_build(String iwhat)
{
	sqlstm = "select * from stockrentalitems_det where origid=" + iwhat;
	return sqlhand.gpSqlFirstRow(sqlstm);
}

Object getGCO_rec(String iwhat)
{
	sqlstm = "select * from rw_goodscollection where origid=" + iwhat;
	return sqlhand.gpSqlFirstRow(sqlstm);
}

