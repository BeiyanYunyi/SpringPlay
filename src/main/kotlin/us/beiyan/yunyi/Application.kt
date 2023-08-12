package us.beiyan.yunyi

import org.springframework.boot.actuate.web.exchanges.HttpExchangeRepository
import org.springframework.boot.actuate.web.exchanges.InMemoryHttpExchangeRepository
import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.web.filter.CommonsRequestLoggingFilter

@Configuration
class AppConfig {
  @Bean
  fun transferService(): HttpExchangeRepository {
    return InMemoryHttpExchangeRepository()
  }

  @Bean
  fun requestLoggingFilter(): CommonsRequestLoggingFilter {
    val loggingFilter = CommonsRequestLoggingFilter()
    loggingFilter.setIncludeClientInfo(true)
    loggingFilter.setIncludeQueryString(true)
    loggingFilter.setIncludePayload(true)
    loggingFilter.setMaxPayloadLength(64000)
    return loggingFilter
  }
}

@SpringBootApplication
class Application

fun main(args: Array<String>) {
  runApplication<Application>(*args)
  // Try adding program arguments via Run/Debug configuration.
  // Learn more about running applications: https://www.jetbrains.com/help/idea/running-applications.html.
}