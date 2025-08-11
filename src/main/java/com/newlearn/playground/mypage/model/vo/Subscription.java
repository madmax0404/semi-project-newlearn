package com.newlearn.playground.mypage.model.vo;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class Subscription {
	private int subNo;
	private int classNo; // 필요한가???
	private int userNo;
	private String dontDisturb;
	private String guestbookNoti;
	private String chatNoti;
	private String friendRequestNoti;
	private String classInvitationNoti;
	private String mappingUrl;
}
