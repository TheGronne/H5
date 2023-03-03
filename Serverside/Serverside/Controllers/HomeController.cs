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
        private readonly ILogger<HomeController> _logger;

        public HomeController(ILogger<HomeController> logger)
        {
            _logger = logger;
        }

        public IActionResult Index()
        {
            var userId = getLoggedInUserId();
            if (userId != null)
            {
                TempData["id"] = userId;
                return RedirectToAction("TodoOverview", "Admin");
            }
            else
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
    }
}