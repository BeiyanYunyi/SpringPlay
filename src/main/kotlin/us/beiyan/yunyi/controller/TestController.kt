package us.beiyan.yunyi.controller

import org.springframework.http.MediaType
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController
import java.util.*

@RestController
@RequestMapping("/")
class TestController {
  @GetMapping("/", produces = [MediaType.APPLICATION_JSON_VALUE])
  fun get(): Any = "\"Hello World\""
}