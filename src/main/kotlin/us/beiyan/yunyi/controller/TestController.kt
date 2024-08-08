package us.beiyan.yunyi.controller

import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import org.springframework.http.MediaType
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController
import us.beiyan.yunyi.models.Todo
import us.beiyan.yunyi.models.TodoRepository

@RestController
@RequestMapping("/")
class TestController(private val todoRepository: TodoRepository) {
  @GetMapping("/", produces = [MediaType.APPLICATION_JSON_VALUE])
  fun get() = mapOf("message" to "Hell, World!", "status" to "ok")

  @GetMapping("/hello", produces = [MediaType.APPLICATION_JSON_VALUE])
  suspend fun incTodo(): Todo {
    val todo =
            withContext(Dispatchers.IO) {
              todoRepository.save(Todo(content = "123", completed = false))
            }
    return todo
  }
}
