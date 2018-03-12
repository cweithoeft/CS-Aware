package com.cloudpartners.csaware.mock;

import java.time.LocalDateTime;
import java.util.*;

import com.cloudpartners.csaware.model.AdminRecord;
import com.cloudpartners.csaware.model.ThreatRecord;
import com.google.gson.*;
import sun.awt.windows.ThemeReader;

public class MockThreatAPI {

	private static AdminRecord adminRecord;
	private static Random random = new Random();
	private static final int MAX_SEVERITY = 5;
	private static final int MAX_THREATS = 1500;
	private static final int MAX_THREAT_RECORDS = 25;
	private static long id = 100000;

	private String[] typeList = new String[]{"DDOS", "Phishing", "Windows Virus", "Malware", "Ransomware", "Other", "MAC virus", "SQL injection"};
	private Integer[] typeNumber = new Integer[] {11, 12, 13, 14, 15, 16, 17,18};
	private List<String> threatTypeList = Arrays.asList(typeList);
	private List<Integer> threatTypeNumberList = Arrays.asList(typeNumber);
	private int threatTyleListLength = threatTypeList.size();

	public MockThreatAPI() {
		adminRecord = new AdminRecord();
		buildAdminRecord();
	}

	public AdminRecord getAdminRecord() {
		return adminRecord;
	}

	public void updateMockThreatRecord() {
		buildAdminRecord();
	}

	private void buildAdminRecord() {
		String idAsString = ((Long) id++).toString();
		adminRecord.setId(idAsString);
		LocalDateTime now = LocalDateTime.now();
		LocalDateTime startTime = now.minusMinutes(11);
		LocalDateTime endTime = now.minusMinutes(1);
		adminRecord.setReportTime(now);
		adminRecord.setAnalysePeriodStartTime(startTime);
		adminRecord.setAnalysePeriodEndTime(endTime);
		adminRecord.setListOfThreats(generateThreatRecords());
		List<ThreatRecord> records = adminRecord.getListOfThreats();
		Iterator<ThreatRecord> iterator = records.iterator();
		int level = Integer.MIN_VALUE;
		while (iterator.hasNext()) {
			int severity = iterator.next().getSeverity();
			if (severity > level) level = severity;
		}
		adminRecord.setThreatLevel(level);
		adminRecord.setNumberOfThreatRecords(adminRecord.getListOfThreats().size());

	}

	private List<ThreatRecord> generateThreatRecords() {
		List<ThreatRecord> threatRecords = new ArrayList<>();

		int threats = random.nextInt(MAX_THREAT_RECORDS) + 1;
		for (int i = 0; i < threats; i++) {
			ThreatRecord threatRecord = new ThreatRecord();
			int index = random.nextInt(threatTyleListLength);
			threatRecord.setThreatType(threatTypeList.get(index));
			threatRecord.setThreatTypeNumber(threatTypeNumberList.get(index));
			threatRecord.setSeverity(random.nextInt(MAX_SEVERITY));
			threatRecord.setThreatSubtupe("some sub type");
			threatRecord.setNumberOfThreats(random.nextInt(MAX_THREATS) + 1);
			threatRecords.add(threatRecord);
		}
		return threatRecords;
	}

	@Override
	public String toString() {
		Gson gson = new Gson();
		return gson.toJson(adminRecord);
	}
}
