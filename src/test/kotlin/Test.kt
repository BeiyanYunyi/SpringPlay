package us.beiyan.yunyi

import org.assertj.core.api.Assertions.assertThat
import org.junit.jupiter.api.Test
import org.springframework.boot.test.context.SpringBootTest

@SpringBootTest
class ApplicationTest {
  @Test
  fun test2() {
    assertThat(1).isEqualTo(1)
  }

  @Test
  fun test() {
    assertThat(1).isEqualTo(2)
  }
}
