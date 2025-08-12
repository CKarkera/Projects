package com.ecommerce.test;

import com.ecommerce.test.base.BaseTest;
import com.ecommerce.pages.LoginPage;
import org.openqa.selenium.WebDriver;
import org.testng.Assert;
import org.testng.annotations.Test;


public class LoginTest extends BaseTest {

    @Test
    public void testLoginWithValidCredentials() {
        driver.get("https://opensource-demo.orangehrmlive.com");

        LoginPage loginPage = new LoginPage(driver);
        loginPage.login("Admin", "admin123");

        Assert.assertTrue(loginPage.isLoginSuccessful(), "Login failed - dashboard not loaded.");
    }
}

