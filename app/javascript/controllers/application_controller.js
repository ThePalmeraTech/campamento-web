import { Application } from "@hotwired/stimulus"
import HelloController from "./hello_controller"
import PaymentController from "./payment_controller"
import NotificationController from "./notification_controller"
import PaginationController from "./pagination_controller"



const application = Application.start()
application.register("hello", HelloController)
application.register("payment", PaymentController)
application.register("notification", NotificationController)
application.register("pagination", PaginationController)
