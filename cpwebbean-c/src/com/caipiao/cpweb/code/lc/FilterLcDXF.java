package com.caipiao.cpweb.code.lc;

import java.util.HashMap;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import com.caipiao.cpweb.code.CodeBean;
import com.caipiao.cpweb.code.FilterBase;
import com.caipiao.cpweb.code.FilterResult;
import com.caipiao.plugin.helper.CodeFormatException;

public class FilterLcDXF extends FilterBase{

	public static final HashMap<String, String> dxfMaps = new HashMap<String, String>();
	
	static{
		dxfMaps.put("3", "3");
		dxfMaps.put("0", "0");
	}
	
	@Override
	public void filter(CodeBean bean, FilterResult result) throws CodeFormatException {
		if(bean.getItemType() == CodeBean.NOITEM){
			doSimple(bean, result);
		}else if(bean.getItemType() == CodeBean.HAVEITEM){
			//检测投注选项
			String codeString = bean.getCodeitems();
			HashMap<String, String> codeMaps = new HashMap<String, String>();
			if(codeString != null){
				codeString = codeString.replaceAll("\\s+", "");
				String [] codeitems = codeString.split(",");
				for(int i = 0; i < codeitems.length; i++){
					String [] ccs = codeitems[i].split("=");
					if(ccs.length != 2){
						throw new CodeFormatException(-1, "投注选项替换格式不符合要求", bean.getCode());
					}
					codeMaps.put(ccs[1].trim(), ccs[0].trim());
				}
			}
			
			Pattern pattern = Pattern.compile("\\s*\\[大小分\\](.+)\\|((\\s*\\d+\\s*\\*\\s*\\d+\\s*,\\s*)*(\\s*\\d+\\s*\\*\\s*\\d+\\s*))");
			Matcher matcher = pattern.matcher(bean.getCode());
			
			if(matcher.find()){
				doDyjWeb(bean, result, matcher.group(1),matcher.group(2), codeMaps);
				return;
			}
			
			pattern = Pattern.compile("\\s*DXF\\s*\\|(.+)\\|((\\s*\\d+\\s*\\*\\s*\\d+\\s*,\\s*)*(\\s*\\d+\\s*\\*\\s*\\d+\\s*))");
			matcher = pattern.matcher(bean.getCode());
			if(matcher.find()){
				doDyjWeb(bean, result, matcher.group(1),matcher.group(2), codeMaps);
				return;
			}
			
			pattern = Pattern.compile("\\s*dxf\\s*\\|(.+)\\|((\\s*\\d+\\s*\\*\\s*\\d+\\s*,\\s*)*(\\s*\\d+\\s*\\*\\s*\\d+\\s*))");
			matcher = pattern.matcher(bean.getCode());
			if(matcher.find()){
				doDyjWeb(bean, result, matcher.group(1),matcher.group(2), codeMaps);
				return;
			}
			result.setCurrentCode("");
		}
	}
	
	/**
	 * 兼容格式
	 * [大小分]85=3,86=3,87=0,88=3,89=1,90=1,91=0|7*1
	 * dxf|85=3,86=3,87=0,88=3,89=1,90=1,91=0|7*1
	 * @param bean
	 * @param result
	 * @param code
	 * @param codeMaps
	 * @throws CodeFormatException
	 */
	private void doDyjWeb(CodeBean bean, FilterResult result, String code,String guoguan, HashMap<String, String> codeMaps) throws CodeFormatException{
		HashMap<String, String> teamsMaps = new HashMap<String, String>();
		String [] cs = code.replaceAll("\\s*", "").split(",");
		StringBuffer sb = new StringBuffer();
		sb.append(bean.getPlaytype());
		sb.append("|");
		int len = cs.length;
		//String gg = len + "*1";
		String gg = guoguan.replaceAll("\\s*", "");
		/*
		if(bean.getGuoguan().equals("1*1") && !(bean.getGuoguan().equals(gg))){
			throw new CodeFormatException(-1, "浮动奖金玩法仅支持单关投注", bean.getCode());
		}
		
		if(gg.equals("1*1") && !(bean.getGuoguan().equals("1*1"))){
			throw new CodeFormatException(-1, "固定奖金玩法不支持单关投注", bean.getCode());
		}
		*/
		//检查玩法和过关方式是否匹配
		if(!LcUtil.check(bean.getPlaytype(), gg)){
			throw new CodeFormatException(-1, "过关方式和玩法不匹配", bean.getCode());
		}
		
		bean.setGuoguan(gg);
		
		for(int i = 0; i < len; i++){
			String [] ccs = cs[i].split("=");
			if(ccs.length != 2){
				throw new CodeFormatException(-1, "投注格式不符合要求", bean.getCode());
			}
			
			try {
				Integer.parseInt(ccs[0]);
			} catch (Exception e) {
				throw new CodeFormatException(-1, "投注场次不符合要求", bean.getCode());
			}
			
			teamsMaps.put(ccs[0], ccs[0]);
			
			sb.append(ccs[0]);
			sb.append("=");
			
			String [] csc = ccs[1].split("/");
			int clen = csc.length;
			HashMap<String, String> tmpMaps = new HashMap<String, String>();
			for(int j = 0; j < clen; j++){
				String value = codeMaps.get(csc[j]);
				if(value == null){
					sb.append(getCodeItem(csc[j], bean));
					tmpMaps.put(csc[j], csc[j]);
				} else {
					sb.append(getCodeItem(value, bean));
					tmpMaps.put(value, value);
				}
				if(j != clen - 1){
					sb.append("/");
				}
			}
			if(tmpMaps.size() != clen){
				throw new CodeFormatException(-1, "投注选项处理后存在重复", bean.getCode());
			}
			tmpMaps.clear();
			sb.append(",");
		}
		if(teamsMaps.size() != len){
			throw new CodeFormatException(-1, "投注场次存在重复", bean.getCode());
		}
		//teamsMaps.clear();
		code = sb.toString();
		if(code.endsWith(",")){
			code = code.substring(0, code.lastIndexOf(","));
		}
		
		code += "|" + bean.getGuoguan();
		
		result.putGglist(gg);
		result.putItems(teamsMaps);
		result.addCode(code);
	}
	
	/**
	 * 兼容格式
	 * 11,31,30,13,33,30
	 * 11-31-30-13-33-30 
	 * 113130133330
	 * 11 31 30 13 33 30
	 * 11,31,30,**,13,33,**,**,30,**,** 
	 * 113130##1333####30 
	 * @param bean
	 * @param result
	 * @throws CodeFormatException
	 */
	private void doSimple(CodeBean bean, FilterResult result) throws CodeFormatException{
		//检查玩法和过关方式是否匹配
		
		if(!LcUtil.check(bean.getPlaytype(), bean.getGuoguan())){
			throw new CodeFormatException(-1, "过关方式和玩法不匹配", bean.getCode());
		}

		//兼容各种投注分割符号
		String code = bean.getCode();
//		code = code.replaceAll(",|-|\\s+|\\*|\\#", "");
//		//code = code.replaceAll("\\*", "#");
		code = code.replaceAll(",|-|\\s+", "");
		code = code.replaceAll("\\*", "#");
		int len = code.length();
		
		//检测投注场次
		String itemString = bean.getTeamitems(); 
		String [] teamitems = itemString.split(",");
		int teamlen = teamitems.length;
		if(teamlen < len){
			throw new CodeFormatException(-1, "所选场次数量不能少于实际投注场次数量", bean.getCode());
		}
		HashMap<String, String> teamsMaps = new HashMap<String, String>();
		for(String s: teamitems){
			try {
				Integer.parseInt(s);
			} catch (Exception e) {
				throw new CodeFormatException(-1, "所选场次不符合要求", bean.getCode());
			}
			teamsMaps.put(s, s);
		}
		if(teamsMaps.size() != teamlen){
			throw new CodeFormatException(-1, "所选场次存在重复场次", bean.getCode());
		}
		
		//检测投注选项
		String codeString = bean.getCodeitems();
		HashMap<String, String> codeMaps = new HashMap<String, String>();
		if(codeString != null){
			codeString = codeString.replaceAll("\\s+", "");
			String [] codeitems = codeString.split(",");
			for(int i = 0; i < codeitems.length; i++){
				String [] ccs = codeitems[i].split("=");
				if(ccs.length != 2){
					throw new CodeFormatException(-1, "投注选项替换格式不符合要求", bean.getCode());
				}
				codeMaps.put(ccs[1].trim(), ccs[0].trim());
			}
		}
		
		//生成标准格式
		StringBuffer sb = new StringBuffer();
		sb.append(bean.getPlaytype());
		sb.append("|");
		int count = 0;
		for(int i = 0; i < len; i++){
			String tmp = String.valueOf(code.charAt(i));
			if("#".equals(tmp)){
				continue;
			}
			sb.append(teamitems[i]);
			sb.append("=");
			
			String value = codeMaps.get(tmp);
			if(value == null){
				sb.append(getCodeItem(tmp, bean));
			}else{
				sb.append(getCodeItem(value, bean));
			}
			sb.append(",");
			count++;
		}
		if(count < LcUtil.getType(bean.getGuoguan())){
			throw new CodeFormatException(-1, "场次不足支持过关方式", bean.getCode());
		}
		
		code = sb.toString();
		if(code.endsWith(",")){
			code = code.substring(0, code.lastIndexOf(","));
		}
		
		code += "|" + bean.getGuoguan();

		result.putItems(teamsMaps);
		result.addCode(code);
	}
	
	/**
	 * 投注项验证
	 * 3,1,0
	 * @param value
	 * @param bean
	 * @return
	 * @throws CodeFormatException
	 */
	private String getCodeItem(String value, CodeBean bean) throws CodeFormatException{
		if(!dxfMaps.containsKey(value)){
			throw new CodeFormatException(-1, "处理转换后号码不符合投注要求", bean.getCode());
		}
		return dxfMaps.get(value);
	}
	
//	public static void main(String[] args) {
//		
//		List<String> nlist = new ArrayList<String>();
//		nlist.add("3000");
////		nlist.add("3-3-1-0-3-1");
////		nlist.add("331303");
////		nlist.add("3 3 1 0 3 1");
////		nlist.add("3,3,1,*,0,3,*,*,1,*,*");
////		nlist.add("331#03##1");
//		
//		List<String> ylist = new ArrayList<String>();
//		ylist.add("dxf | 110518003=0,110518006=5,110518007=0 | 2*1 _ 1000 ");
//		
//		FilterResult fr = new FilterResult();
//		try {
//			FilterLcSF spf = new FilterLcSF();
//			CodeBean bean = new CodeBean();
//			bean.setLottype(97);
//			bean.setPlaytype("DXF");
//			bean.setCodeitems("3=5,1=1,0=0");
//			bean.setTeamitems("1001,1002,1003,1004");
//			bean.setGuoguan("4*1");
//			bean.setItemType(CodeBean.NOITEM);
//			
////			for(String c : nlist){
////				bean.setCode(c);
////				spf.doFilterLc(bean, fr);
////			}
////			
//			for(String c : ylist){
//				bean.setItemType(CodeBean.HAVEITEM);
//				bean.setCode(c);
//				spf.doFilterLc(bean, fr);
//			}
//			
//			System.out.println(fr.getAllCode());
//		} catch (CodeFormatException e) {
//			e.printStackTrace();
//		}
//	}
}