package com.ecommerce.pages;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;

public class DashboardPage {

    WebDriver driver;

    public DashboardPage(WebDriver driver) {
        this.driver = driver;
    }

    // Locators
    private By title = By.tagName("h6");
    private By profileDropdown = By.className("oxd-userdropdown-tab");
    private By timeAtWork = By.xpath("//p[text()='Time at Work']");
    private By myActions = By.xpath("//p[text()='My Actions']");
    private By quickLaunch = By.xpath("//p[text()='Quick Launch']");
    private By buzzPosts = By.xpath("//p[text()='Buzz Latest Posts']");
    private By sidebar = By.className("oxd-sidepanel");

    // Actions
    public String getDashboardTitle() {
        return driver.getTitle();
    }

    public String getCurrentUrl() {
        return driver.getCurrentUrl();
    }

    public boolean isWidgetDisplayed(String widgetName) {
        return driver.getPageSource().contains(widgetName);
    }

    public boolean isProfileDropdownVisible() {
        return driver.findElement(profileDropdown).isDisplayed();
    }

    public boolean isSidebarVisible() {
        return driver.findElement(sidebar).isDisplayed();
    }
}
