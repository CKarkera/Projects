package com.ecommerce.test.factory;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.firefox.FirefoxDriver;
import org.openqa.selenium.edge.EdgeDriver;
import java.time.Duration;

public class DriverFactory {

        private static ThreadLocal<WebDriver> tlDriver = new ThreadLocal<>();

        // Initialize driver based on browser
        public WebDriver initDriver(String browser) {
            if (browser.equalsIgnoreCase("chrome")) {
                tlDriver.set(new ChromeDriver());
            } else if (browser.equalsIgnoreCase("firefox")) {
                tlDriver.set(new FirefoxDriver());
            } else if (browser.equalsIgnoreCase("edge")) {
                tlDriver.set(new EdgeDriver());
            } else {
                System.out.println("Please pass the correct browser: " + browser);
            }

            getDriver().manage().timeouts().implicitlyWait(Duration.ofSeconds(10));
            getDriver().manage().window().maximize();
            return getDriver();
        }

        // Get driver safely
        public static WebDriver getDriver() {
            return tlDriver.get();
        }

        // Quit driver
        public static void quitDriver() {
            if (getDriver() != null) {
                getDriver().quit();
                tlDriver.remove();
            }
        }
}