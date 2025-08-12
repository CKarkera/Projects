package com.ecommerce.test;

import com.ecommerce.pages.DashboardPage;
import com.ecommerce.pages.LoginPage;
import com.ecommerce.test.base.BaseTest;
import org.testng.Assert;
import org.testng.annotations.Test;

public class DashboardTest extends BaseTest {

        @Test
        public void verifyDashboardPageElements() {
            // Login first
            LoginPage loginPage = new LoginPage(driver);
            loginPage.login("Admin", "admin123");

            DashboardPage dashboardPage = new DashboardPage(driver);

            // Assertions
            Assert.assertTrue(dashboardPage.getDashboardTitle().contains("OrangeHRM"), "Title mismatch");
            Assert.assertTrue(dashboardPage.getCurrentUrl().contains("dashboard"), "URL mismatch");
            Assert.assertTrue(dashboardPage.isWidgetDisplayed("Time at Work"), "Time at Work widget not found");
            Assert.assertTrue(dashboardPage.isWidgetDisplayed("My Actions"), "My Actions widget not found");
            Assert.assertTrue(dashboardPage.isWidgetDisplayed("Quick Launch"), "Quick Launch widget not found");
            Assert.assertTrue(dashboardPage.isWidgetDisplayed("Buzz Latest Posts"), "Buzz widget not found");
            Assert.assertTrue(dashboardPage.isProfileDropdownVisible(), "Profile dropdown not visible");
            Assert.assertTrue(dashboardPage.isSidebarVisible(), "Sidebar not visible");
        }
}
