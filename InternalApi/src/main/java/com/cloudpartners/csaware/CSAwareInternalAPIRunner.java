package com.cloudpartners.csaware;

import com.cloudpartners.csaware.mock.MockThreatAPI;
import com.cloudpartners.csaware.model.AdminRecord;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Iterator;
import java.util.Properties;
import java.util.Set;

import static spark.Spark.get;

public class CSAwareInternalAPIRunner {

	private Properties properties;
	private static Logger logger = LoggerFactory.getLogger(CSAwareInternalAPI.class);
	private static MockThreatAPI mockThreatAPI;
	private static final String THREATS = "threats";
	private static final String CONFIG = "config";

	public CSAwareInternalAPIRunner(Properties properties) {
		this.properties = properties;
		mockThreatAPI = new MockThreatAPI();
	}

	public void runCSAwareInternalAPI() {

		logger.info("Running CSAware Internal API");
		Set<Object> allKeys = properties.keySet();
		Iterator<Object> iterator = allKeys.iterator();
		while (iterator.hasNext()) {
			String key = (String) iterator.next();
			logger.debug("Property key: {} value: {}",key, properties.getProperty(key));
		}

		get ("/api/:name" , (req, res) -> {
			StringBuffer result = new StringBuffer();
			String apiName = req.params(":name");
			res.type("application/json");
			if (apiName.equals(THREATS)) {
				AdminRecord adminRecord = mockThreatAPI.getAdminRecord();
				mockThreatAPI.updateMockThreatRecord();
				String temp = adminRecord.toJSON();
				result.append(temp);
			} else if (apiName.equals(CONFIG)) {
				result.append("some config from GraphingWiki");
			} else {
				result.append("Unknown api name: [" + apiName + "]");
			}
			logger.info("response is: {}", result.toString());
			return result.toString();
		});

	}
}
