package com.cloudpartners.csaware;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class CSAwareInternalAPI {

	public static void main(String [] args) {
		try {
			CSAwareInternalAPIRunner runner = new CSAwareInternalAPIRunner(loadProperties());
			runner.runCSAwareInternalAPI();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private static Properties loadProperties () throws Exception {
		Properties properties = new Properties();
		String env = System.getenv("env");
		if (env == null || env.isEmpty()) {
			env = "dev";
		}
		System.out.println("Environment is: " + env);

		try {
			String path = "/META-INF/env/" + env + ".properties";
			InputStream inputStream = CSAwareInternalAPI.class.getResourceAsStream(path);
			if (inputStream != null) {
				properties.load(inputStream);
			} else {
				throw new Exception("Can't open environment file for: [" + env + "] path: [" + path + "]");
			}
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}

		return properties;
	}
}
