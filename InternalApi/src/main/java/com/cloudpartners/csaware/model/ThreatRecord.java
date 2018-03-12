package com.cloudpartners.csaware.model;

import lombok.Data;

@Data
public class ThreatRecord {

	private String threatType;
	private int threatTypeNumber;
	private String threatSubtupe;
	private int severity;
	private int numberOfThreats;

	public ThreatRecord() {

	}
}
