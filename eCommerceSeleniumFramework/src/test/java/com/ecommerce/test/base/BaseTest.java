package com.ecommerce.test.base;

import com.ecommerce.test.utils.ScreenshotUtil;
import io.github.bonigarcia.wdm.WebDriverManager;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.testng.ITestResult;
import org.testng.annotations.BeforeMethod;
import org.testng.annotations.*;

import java.time.Duration;

public class BaseTest {

    protected WebDriver driver;

        @BeforeMethod
        public void setUp() {
            WebDriverManager.chromedriver().setup();
            driver = new ChromeDriver();
            driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(10));
            driver.manage().window().maximize();
        }

        @AfterMethod
        public void tearDown(ITestResult result) {
            if (ITestResult.FAILURE == result.getStatus()) {
                ScreenshotUtil.capture(driver, result.getName());
            }
            driver.quit();
        }
    }
