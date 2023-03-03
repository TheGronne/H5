using System.ComponentModel.DataAnnotations;
using Serverside.Models;

namespace Serverside.Models
{
    public class Todo
    {
        [Key]
        public int ID { get; set; }
        [Required]
        public string UserID { get; set; }
        [Required]
        public string Name { get; set; }
        [Required]
        public string Description { get; set; }
    }
}
