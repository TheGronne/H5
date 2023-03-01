using System.ComponentModel.DataAnnotations;
using ServersideProgrammering.Models;

namespace ServersideProgrammering.Models
{
    public class User
    {
        [Key]
        public int ID { get; set; }
        [Required]
        public string FirstName { get; set; }
        public string LastName { get; set; }
        [Required]
        public string Password { get; set; }
    }
}
