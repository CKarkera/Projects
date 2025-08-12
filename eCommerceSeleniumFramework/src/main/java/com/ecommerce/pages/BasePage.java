package com.ecommerce.pages;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.ui.WebDriverWait;
import java.time.Duration;
import org.openqa.selenium.support.ui.ExpectedConditions;

public class BasePage {

        protected WebDriver driver;
        private WebDriverWait wait;

        // Constructor
        public BasePage(WebDriver driver) {
            this.driver = driver;
            wait = new WebDriverWait(driver, Duration.ofSeconds(20)); // Wait for 20 seconds
        }

        // Wait for element to be visible
        public void waitForVisibility(WebElement element) {
            wait.until(ExpectedConditions.visibilityOf(element));
        }

        // Click an element
        public void click(WebElement element) {
            waitForVisibility(element);
            element.click();
        }

        // Enter text in textbox
        public void type(WebElement element, String text) {
            waitForVisibility(element);
            element.clear();
            element.sendKeys(text);
        }

        // Get element text
        public String getText(WebElement element) {
            waitForVisibility(element);
            return element.getText();
        }

        // Check if element is displayed
        public boolean isElementDisplayed(WebElement element) {
            try {
                waitForVisibility(element);
                return element.isDisplayed();
            } catch (Exception e) {
                return false;
            }
        }
}