﻿<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.caipiao.cpweb.trade.jclq.MatchBean"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="com.caipiao.cpweb.trade.jclq.TradeJcBeanImpl"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="/css/159cai.css"  rel="stylesheet" type="text/css" />
<link href="/css/new159cai.css"  rel="stylesheet" type="text/css" />
<title>竞彩篮球混合投注_发起代购_网上购买_在线投注_网上合买_159彩票网</title>
<meta name="Keywords" content="竞彩篮球投注,竞彩篮球代购,竞彩篮球合买" />
<meta name="Description" content="159彩票竞彩篮球频道为您提供竞彩篮球购买、竞彩篮球投注、竞彩篮球合买、包括单式投注、复式投注等" />
<script type="text/javascript" src="/public/jq2.js"></script>
<script type="text/javascript" src="/public/jq.js"></script>
<script type="text/javascript" src="/public/159cp.js"></script>
<script type="text/javascript" src="/public/chklogin.js"></script>
<script type="text/javascript" src="/public/menu.js"></script>
<script type="text/javascript" src="/jc/js/buy_form_hh.js"></script>
</head>
<%
List<MatchBean> mb = (List<MatchBean>) request.getAttribute("mb");
HashMap<String,String[]> mList = (HashMap<String,String[]>) request.getAttribute("mList");

String playid = (String) request.getAttribute("playid");
String codes = (String) request.getAttribute("newcodes");
%>
<body>
<!-- 头部内容 -->  
<!--#include virtual="/cc/header.html"-->
<!--#include virtual="/cc/nav.html"-->
<!-- 头部内容 --> 
<div id="container">
<div class=breadcrumb><p>您现在的位置：<a href="/" title="网上买彩票"><font>159彩</font></a> &gt; <a href="/lc/" title="竞彩篮球"><font>竞彩篮球</font></a></p></div>
<div class="gm_msg">
 <table width="100%" border="0" cellspacing="0" cellpadding="0">
 <colgroup>
  <col width="115" />
  <col width="145" />
  <col width="300" />
  <col width="280" />
  <col />
 </colgroup>
  <thead><tr>
    <td colspan="5"><h3>购彩信息</h3></td>
  </tr></thead>
  <tbody>
  <tr class="first">
    <td>场次</td>
    <td>比赛时间</td>
    <td>客队 VS 主队</td>
	<td>玩法</td>
    <td>投注内容</td>
  </tr>
<%
String ratelist = "";
//newcodes--HH|130326303>RFSF=0+DXF=0/3,130326302>RFSF=0/3+SFC=02/03/14/15,130326301>SF=0/3|2*1,3*1|1
String newcodes=codes.replace("HH|", "");
newcodes=newcodes.substring(0,newcodes.indexOf("|"));

String[] cs=newcodes.split(",");
for (int j=0;j<cs.length;j++){

	String[] t1 = new String[2];
	
	t1[0] = cs[j].substring(0,cs[j].indexOf(">"));
	t1[1] = cs[j].substring(cs[j].indexOf(">")+1);//SPF=3/1+JQS=0/1+CBF=1:0/9:9/0:9+BQC=3-3
	
	System.out.println("jsp:a="+t1[0]);
	System.out.println("jsp:b="+t1[1]);//jsp:a=130316020  jsp:b=>SPF=3/1+BQC=3-3/3-1/1-1/1-0

	String mid= t1[0];
	String value= t1[1];//.substring(1,t1[1].length()-1);
	
	String[] xz = value.split("\\+");
	int ni = xz.length;//同一场选择了多少种玩法
	int count=0;
	for(int ii=0;ii<mb.size();ii++){
		if(mid.equals(mb.get(ii).getItemid())){
			count=ii;
			break;
		}
	}
	String spv=mb.get(count).getSpv();
	
	StringBuffer sb = new StringBuffer();
	String tmprate="";
	 	sb.append("<tr><td title=\""+mb.get(count).getItemid()+"\" rowspan=\""+ni+"\">"+mb.get(count).getMname()+"</td>");
	 	sb.append("<td rowspan=\""+ni+"\">"+mb.get(count).getBt()+"</td>");
	 	sb.append("<td rowspan=\""+ni+"\">"+mb.get(count).getGn()+" VS "+mb.get(count).getHn()+"</td>");
	 	String closestr = mb.get(count).getClose();
	 	String[] close = closestr.split("\\|");
	 	String zclose = close[1] ;
	 	String rclose = close[0] ;
	 	String rcloses = "";
	 	String zcloses = "";
	 	if(rclose.indexOf("-")>-1){
	 		rcloses="&nbsp;<font color='green'>"+rclose+"</font>";
		}else{
			rcloses="&nbsp;<font color='red'>"+rclose+"</font>";
		}
	 	zcloses="&nbsp;<font color='red'>"+zclose+"</font>";

	 	for (int i=0;i<ni;i++){	
	 		String[] xzstr = xz[i].split("=");
	 		String pty=xzstr[0];
	 		String n1=xzstr[1];
	 		String n2="";
	 		String n3="";
	 		String n4="";
	 		if (pty.equalsIgnoreCase("SF")){
	 			if(i>0){sb.append("<tr>");}
				sb.append("<td>胜负</td>");
				sb.append("<td>");
	 			String[] n1str = n1.split("/");
	 			for (int m=0;m<n1str.length;m++){
	 				String n11=n1str[m];
	 				n3=n11;
		 			n4=TradeJcBeanImpl.SFMapname.get(n11);
		 			n2=TradeJcBeanImpl.getsp(spv,TradeJcBeanImpl.HHSPMaps.get(n4))+"";
		 			sb.append(n4+"("+n2+") ");
		 			tmprate+=n3+"#"+n2+",";
	 			}
	 			sb.append("</td>");
				sb.append("</tr>");
	 		}else if (pty.equalsIgnoreCase("RFSF")){
	 			if(i>0){sb.append("<tr>");}
				sb.append("<td>让分胜负"+rcloses+"</td>");
				sb.append("<td>");
	 			String[] n1str = n1.split("/");
	 			for (int m=0;m<n1str.length;m++){
	 				String n11=n1str[m];
	 				n3=n11.replace("0", "21").replace("3", "20");
	 				n4=n11.replace("0", "让分主负").replace("3", "让分主胜");
	 				System.out.println("jsp:n3="+n3);
	 				System.out.println("jsp:n4="+n4);
	 				System.out.println("jsp:n3--="+TradeJcBeanImpl.HHSPMaps.get(n3));
	 				System.out.println("jsp:spv="+spv);
		 			n2=TradeJcBeanImpl.getsp(spv,TradeJcBeanImpl.HHSPMaps.get(n3))+"";
		 			sb.append(n4+"("+n2+") ");
		 			tmprate+=n11+"#"+n2+",";
	 			}
	 			sb.append("</td>");
				sb.append("</tr>");
	 		}else if (pty.equalsIgnoreCase("DXF")){
	 			if(i>0){sb.append("<tr>");}
				sb.append("<td>大小分"+zcloses+"</td>");
				sb.append("<td>");
	 			String[] n1str = n1.split("/");
	 			for (int m=0;m<n1str.length;m++){
	 				String n11=n1str[m];
	 				n3=n11;
	 				n4=TradeJcBeanImpl.DXFMapname.get(n11);
					n2=TradeJcBeanImpl.getsp(spv,TradeJcBeanImpl.HHSPMaps.get(n4))+"";
		 			sb.append(n4+"("+n2+") ");
		 			tmprate+=n3+"#"+n2+",";
	 			}
	 			sb.append("</td>");
				sb.append("</tr>");
			}else if (pty.equalsIgnoreCase("SFC")){
				if(i>0){sb.append("<tr>");}
				sb.append("<td>胜分差</td>");
				sb.append("<td>");
	 			String[] n1str = n1.split("/");
	 			for (int m=0;m<n1str.length;m++){
	 				String n11=n1str[m];
	 				n3=n11;
					n4=TradeJcBeanImpl.SFCMapname.get(n11);
					n2=TradeJcBeanImpl.getsp(spv,TradeJcBeanImpl.HHSPMaps.get(n11))+"";
					sb.append(n4+"("+n2+") ");
		 			tmprate+=n3+"#"+n2+",";
	 			}
	 			sb.append("</td>");
				sb.append("</tr>");
			}
	 	}
	out.print(sb);
	sb=null;
}
ratelist="";
%>
  <tr>
    <td colspan="5" class="sum">投注<font>${beishu}</font>倍&nbsp;&nbsp;&nbsp;&nbsp; 过关方式：<font>${sgtypename}</font>
    <%
    String ismix = (String) request.getAttribute("ismix");
	if(ismix.equals("1")) {
    %>
    	(<font color="red">去除单一玩法串投注</font>)
	<%} else {%>
    	(<font color="red">允许单一玩法串投注</font>)
    <%}%><span class="annot">方案奖金以出票时官网奖金为准</span>
    </td>
  </tr>
  <tr>
    <td colspan="5" class="last">方案注数<font>${zhushu}</font>注，您需要支付<font>${totalmoney}</font>元</td>
  </tr>
  <tr>
    <td colspan="5" class="last"><a href="javascript:void(0);" class="gm_but"  id="dg_btn" name="dg_btn">确认无误，去付款</a>
    <p><input type="checkbox" checked="checked"  id="agreement" />我已阅读并同意《<a href="/help/help_yffwxy.html"  target="_blank">用户合买代购协议</a>》</p>
    </td>
  </tr>
  </tbody>
</table>
<form method="post" action="" id="buyform">	
<input type='hidden' name='lotid' id="lotid" value='${lotid}'>
<input type='hidden' name='playid' id="playid" value='${playid}'>
<input type='hidden' name='expect' id="expect" value='${expect}'>
<input type="hidden" name="gggroup" id="gggroup" value="${gggroup}">
<input type='hidden' name='sgtype' id="sgtype" value='${sgtype}'>
<input type="hidden" name="sgtypename" id="sgtypename" value="${sgtypename}">
<input type='hidden' name='codes' id="codes" value='${codes}'>
<input type='hidden' name='newcodes' id="newcodes" value='${newcodes}'>
<input type='hidden' name='danma' id="danma" value='${danma}'>
<input type='hidden' name='newdanma' id="newdanma" value='${newdanma}'>
<input type='hidden' name='beishu' id="beishu" value='${beishu}'>
<input type='hidden' name='totalmoney' id="totalmoney" value='${totalmoney}'>
<input type="hidden" name="IsCutMulit" id="IsCutMulit" value="${IsCutMulit}">
<input type="hidden" name="ishm" id="ishm" value="${ishm}">
<input type="hidden" name="source" id="source" value="0">
<input type="hidden" name="playtype" id="playtype" value="${playid}">
<input type="hidden" name="ratelist" id="ratelist" value="<%=ratelist%>">
<input type='hidden' name='ismix' id="ismix" value='${ismix}'>
</form>
</div>
</div>
<!--#include virtual="/cc/footer.html"-->
</body>
</html>