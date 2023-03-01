using Microsoft.AspNetCore.Mvc;
using ServersideProgrammering.Data;
using ServersideProgrammering.Models;
using System.Diagnostics;

namespace ServersideProgrammering.Controllers
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
            return View();
        }

        public IActionResult Register()
        {
            return View();
        }

        public IActionResult GenerateTodo()
        {
            return View();
        }

        public IActionResult TodoOverview()
        {
            //Needs current signed in user
            var user = GetUser("cool");

            bool isValid = BCrypt.Net.BCrypt.Verify("cool", user.Password);

            if (isValid)
            {
                var todos = GetTodos(user);
                return View("TodoOverview", todos);
            }
            else
                return View("Index");
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult LoginRequest(string firstName, string password)
        {
            //Does user exist?
            var user = GetUser(firstName);
            if (user == null)
            {
                ViewBag.ErrorDescription = "User doesn't exist";
                return View("Index");
            }
                

            //Is password valid?
            bool isValid = BCrypt.Net.BCrypt.Verify(password, user.Password);
            if (!isValid)
            {
                ViewBag.ErrorDescription = "Incorrect password";
                return View("Index");
            }
                

            //Success
            var todos = GetTodos(user);
            return View("TodoOverview", todos);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult RegisterRequest(User user)
        {
            if (PostUser(user))
                return View("Index");
            else
            {
                ViewBag.ErrorDescription = "Name already used";
                return View("Register");
            }
                
        }

        public User GetUser(string firstName)
        {
            return _db.Users.SingleOrDefault(x => x.FirstName == firstName);
        }

        //Side note: If this wasn't a one and done applciation, I'd move all validation into middleware and keep db methods simple
        public bool PostUser(User user)
        {
            //Does first name already exist?
            if (_db.Users.SingleOrDefault(x => x.FirstName == user.FirstName) != null)
                return false;

            try
            {
                //Has password -> save user
                user.Password = BCrypt.Net.BCrypt.HashPassword(user.Password);
                _db.Users.Add(user);
                _db.SaveChanges();
                return true;
            }
            catch (Exception ex)
            {
                return false;
            }
        }

        public IEnumerable<Todo> GetTodos(User user)
        {
            var todos = _db.Todos.Where(b => b.UserID == user.ID).ToList();
            return _db.Todos;
        }
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