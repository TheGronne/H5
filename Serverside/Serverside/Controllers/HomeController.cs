using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Serverside.Data;
using Serverside.Models;
using System.Diagnostics;
using System.Security.Claims;
using System.Web;

namespace Serverside.Controllers
{
    public class HomeController : Controller
    {
        private readonly ApplicationDbContext _db;
        private readonly ILogger<HomeController> _logger;

        public HomeController(ILogger<HomeController> logger, ApplicationDbContext db)
        {
            _db = db;
        }

        public IActionResult Index()
        {
            if (getLoggedInUserId() != null)
                return View("TodoOverview");
            else
                return View();
        }

        public IActionResult Logout()
        {
            return Redirect("/Identity/Account/Logout");
        }

        public IActionResult TodoOverview()
        {
            if (getLoggedInUserId() != null)
                return View();
            else
                return View("Index");
        }
        

        public IActionResult GenerateTodo()
        {
            if (getLoggedInUserId() != null)
                return View();
            else
                return View("Index");
        }

        public string getLoggedInUserId()
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            return userId;
        }

        //[HttpGet]
        //[Route("Admin/{id}/todoOverview")]
        //public async IActionResult TodoOverview(int id)
        //{
        //    Needs current signed in user
        //    var user = GetUser("cool");

        //    bool isValid = BCrypt.Net.BCrypt.Verify("cool", user.Password);

        //    if (isValid)
        //    {
        //        var todos = GetTodos(user);
        //        return View("TodoOverview", todos);
        //    }
        //    else
        //        return View("Index");
        //}

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }

        //public IEnumerable<Todo> GetTodos(User user)
        //{
        //    var userId = User.FindFirstValue(ClaimTypes.NameIdentifier) // will give the user's userId
        //    var userName = User.FindFirstValue(ClaimTypes.Name) // will give the user's userName
        //    var todos = _db.Todos.Where(b => b.UserID == user.ID).ToList();
        //    return _db.Todos;
        //}
        public bool PostTodos(Todo todo)
        {
            //Todo needs userid
            try
            {
                todo.Name = BCrypt.Net.BCrypt.HashPassword(todo.Name);
                todo.Description = BCrypt.Net.BCrypt.HashPassword(todo.Description);
                _db.Todos.Add(todo);
                _db.SaveChanges();
                return true;
            }
            catch (Exception ex)
            {
                return false;
                throw ex;
            }
        }
    }
}