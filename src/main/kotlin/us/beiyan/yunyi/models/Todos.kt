package us.beiyan.yunyi.models

import jakarta.persistence.Entity
import jakarta.persistence.GeneratedValue
import jakarta.persistence.Id
import jakarta.persistence.Table
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@Entity
@Table(name = "Todos")
data class Todo(
        @Id @GeneratedValue var id: Long = 0,
        var content: String = "",
        var completed: Boolean = false
) {}

@Repository
interface TodoRepository : JpaRepository<Todo, Long> {
    // fun findAll(): List<Todo>
    // fun findById(id: Long): Todo?
    // fun save(todo: Todo): Todo
    // fun deleteById(id: Long)
}
