package com.cloudpartners.csaware.model;

import com.google.gson.Gson;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

@Data
public class AdminRecord {

	private String id;
	private LocalDateTime reportTime;
	private LocalDateTime analysePeriodStartTime;
	private LocalDateTime analysePeriodEndTime;
	private int threatLevel;
	private int numberOfThreatRecords;
	private List<ThreatRecord> listOfThreats;

	public String toJSON() {
		Gson gson = new Gson();
		return gson.toJson(this);
	}
}
