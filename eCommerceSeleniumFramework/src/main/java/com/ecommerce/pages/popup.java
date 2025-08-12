package com.ecommerce.pages;

import org.openqa.selenium.Alert;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

import java.time.Duration;

public class popup {

    public static void main(String args[]) {
        WebDriver driver = new ChromeDriver();
        WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(10));

        try {
            // 1. JavaScript Alert
            driver.get("https://the-internet.herokuapp.com/javascript_alerts");

            // Click to trigger simple alert
            driver.findElement(By.xpath("//button[text()='Click for JS Alert']")).click();
            Alert alert = wait.until(ExpectedConditions.alertIsPresent());
            String alertText = alert.getText();
            System.out.println("Alert text: " + alertText);
            alert.accept();

            // 2. JavaScript Confirm
            driver.findElement(By.xpath("//button[text()='Click for JS Confirm']")).click();
            Alert confirm = wait.until(ExpectedConditions.alertIsPresent());
            String confirmText = confirm.getText();
            System.out.println("Confirm text: " + confirmText);
            confirm.dismiss(); // Click Cancel

            // 3. JavaScript Prompt
            driver.findElement(By.xpath("//button[text()='Click for JS Prompt']")).click();
            Alert prompt = wait.until(ExpectedConditions.alertIsPresent());
            prompt.sendKeys("Test input");
            prompt.accept();

            // 4. Modal Dialog (HTML-based)
            driver.get("https://getbootstrap.com/docs/4.0/components/modal/");

            // Click to open modal
            WebElement modalButton = wait.until(ExpectedConditions.elementToBeClickable(
                    By.xpath("//button[contains(text(), 'Launch demo modal')]")
            ));
            modalButton.click();

            // Wait for modal to appear
            WebElement modal = wait.until(ExpectedConditions.visibilityOfElementLocated(
                    By.xpath("//div[contains(@class, 'modal') and contains(@style, 'display: block')]")
            ));

            // Find and click close button within modal
            WebElement closeButton = modal.findElement(By.xpath(".//button[contains(@class, 'close')]"));
            closeButton.click();

            // Wait for modal to disappear
            wait.until(ExpectedConditions.invisibilityOf(modal));

        } finally {
            driver.quit();
        }
    }
}
