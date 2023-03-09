using Microsoft.AspNetCore.DataProtection;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Serverside.Data;
using Serverside.Models;
using System.Diagnostics;
using System.Security.Claims;
using System.Web;
using System.Linq;

namespace Serverside.Controllers
{
    public class AdminController : Controller
    {
        private readonly ApplicationDbContext _db;
        private readonly ILogger<HomeController> _logger;
        private readonly IDataProtector _protector;

        public AdminController(ILogger<HomeController> logger, ApplicationDbContext db, IDataProtectionProvider provider)
        {
            _db = db;
            _protector = provider.CreateProtector("1235");
        }

        public IActionResult Logout()
        {
            return Redirect("/Identity/Account/Logout");
        }

        [HttpGet]
        [Route("Admin/TodoOverview")]
        public IActionResult TodoOverview()
        {
            string id = TempData["id"].ToString();
            if (id == null)
                if ((id = getLoggedInUserId()) == null)
                    return View("Index");

            TempData["id"] = id;
            var encryptedTodos = GetTodos(id);
            var decryptedTodos = DecryptTodos(encryptedTodos);
            return View(decryptedTodos);
        }

        [HttpGet]
        [Route("Admin/GenerateTodo")]
        public IActionResult GenerateTodo()
        {
            string id = TempData["id"].ToString();
            if (id == null)
                if ((id = getLoggedInUserId()) == null)
                    return View("Index");

            TempData["id"] = id;
            return View();
        }

        public string getLoggedInUserId()
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            return userId;
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }

        public IEnumerable<Todo> GetTodos(string id)
        {
            var todos = _db.Todos.Where(b => b.UserID == id).ToList();
            return todos;
        }

        [HttpPost]
        public IActionResult PostTodos(Todo todo)
        {
            todo.UserID = TempData["id"].ToString();

            todo.Name = _protector.Protect(todo.Name);
            todo.Description = _protector.Protect(todo.Description);

            _db.Todos.Add(todo);
            _db.SaveChanges();

            TempData["id"] = todo.UserID;
            return View("GenerateTodo");
        }

        public IEnumerable<Todo> DecryptTodos(IEnumerable<Todo> encryptedTodos)
        {
            var decryptedTodos = new List<Todo>();
            foreach (var encryptedTodo in encryptedTodos)
            {
                encryptedTodo.Name = _protector.Unprotect(encryptedTodo.Name);
                encryptedTodo.Description = _protector.Unprotect(encryptedTodo.Description);
                decryptedTodos.Add(encryptedTodo);
            }
            return decryptedTodos;
        }
    }
}