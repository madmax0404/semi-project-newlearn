package com.newlearn.playground.common.scheduling;

import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URL;
import java.util.List;

import javax.servlet.ServletContext;

import org.openqa.selenium.By;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.PropertySource;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.newlearn.playground.beerstore.model.service.BeerStoreService;
import com.newlearn.playground.beerstore.model.vo.BeerStore;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
@RequiredArgsConstructor
@PropertySource("classpath:instagram.properties")
public class ScheduleController {
	private final BeerStoreService bService;
	private final ServletContext application;

	@Value("${dataSource.instaUsername}")
	private String username;

	@Value("${dataSource.instaPassword}")
	private String password;

	/*
	 * 1. 고정시간 간격으로 스케쥴링 fixedDelay: 이전 작업 종료 시점으로 일정시간 지연 후 실행. fixedRate: 이전 작업 시작
	 * 시점을 기준으로 일정 간격으로 메서드 수행
	 */
	// @Scheduled(fixedDelay=5000) // 작업 종료 후 5초의 지연시간을 둔 뒤 다시 실행
	public void fixedDelayTask() {
		log.debug("[fixedDelay] 작업 실행 됨 - {}", System.currentTimeMillis());
	}

	// @Scheduled(fixedRate=5000) // 작업 시작 후 5초의 지연시간을 둔 뒤 다시 실행
	public void fixedRateTask() {
		log.debug("[fixedRate] 작업 실행 됨 - {}", System.currentTimeMillis());
	}

	/*
	 * 2. cron 표현식
	 * 
	 * cron: 초 분 시 일 월 요일 * * * * * * *: 모든 값(매분, 매초, 매시간, ...). ?: 일, 요일에서만 사용
	 * 가능(일자리에 ?가 들어가는 경우 일수는 신경쓰지 않는다). -: 값의 범위(1-10) ,: 여러 값을 지정(1, 5, 10) /: 증가
	 * 단위(0/2 -> 0초부터 2초간격으로) L: 마지막(배월 말일을 지정할 때 사용) W: 가장 가까운 평일(15W) #: N번째 요일
	 * 
	 * 매일 오전 1시에 어떤 작업을 실행하게 하고 싶다. 0 0 1 * * *
	 * 
	 * 매 시간 30분 0 30 * * * *
	 */
	// @Scheduled(cron="*/5 * * * * *")
	public void testCron() { // 5초마다
		log.debug("[cron] cron 표현식 작업 실행 {}", System.currentTimeMillis());
	}

	@Scheduled(cron = "0 0 8 * * *")
	public void getBeerMenu() throws InterruptedException {
		// 업무 로직
		// 1. DB에 오늘 날짜로 저장된 menu_url이 있는지 확인
		BeerStore beer = bService.checkToday();

		if (beer != null) {
			// 2. 있다면 불러오고
		} else {
			// 3. 없다면 크롤링
			ChromeOptions options = new ChromeOptions();
			options.addArguments("--headless"); // GUI 없이 실행
			WebDriver driver = new ChromeDriver(options);
			driver.get("https://www.instagram.com/");

			Thread.sleep(10000);

			WebElement usernameInput = driver.findElement(By.cssSelector("input[name='username']"));
			WebElement passwordInput = driver.findElement(By.cssSelector("input[name='password']"));
			usernameInput.sendKeys(username);
			passwordInput.sendKeys(password);
			WebElement loginButton = driver.findElement(By.cssSelector("button[type='submit']"));
			loginButton.click();

			Thread.sleep(10000);

			driver.get("https://www.instagram.com/lunch_mz/?hl=ko");

			Thread.sleep(10000);

			List<WebElement> aaguList = driver.findElements(By.cssSelector("._aagu"));

			for (int i = 0; i < aaguList.size(); i++) {
				WebElement aaguElement = aaguList.get(i);
				WebElement imgElement = aaguElement.findElement(By.cssSelector("img"));
				String alt = imgElement.getAttribute("alt");
				if (alt.contains("후식")) {
					((JavascriptExecutor) driver).executeScript("arguments[0].click();", aaguElement);
					break;
				}
			}

			Thread.sleep(10000);

			WebElement menuImg = driver.findElement(By.cssSelector("img[alt*='후식']"));
			String imgUrl = menuImg.getAttribute("src");
			System.out.println(imgUrl);

			try {
				downloadImage(imgUrl, application);
			} catch (IOException e) {
				e.printStackTrace();
			}

			int result = bService.insertBeer(imgUrl);
		}
	}

	public static void downloadImage(String imgUrl, ServletContext application) throws IOException {
		String savePath = "/resources/assets/img/beer/beer.jpg";
		String serverFolderPath = application.getRealPath(savePath);
		URL url = new URL(imgUrl);
		try (InputStream in = url.openStream(); OutputStream out = new FileOutputStream(serverFolderPath)) {
			byte[] buffer = new byte[4096];
			int n;
			while ((n = in.read(buffer)) != -1) {
				out.write(buffer, 0, n);
			}
		}
		System.out.println("저장 완료: " + savePath);
	}
}
