﻿using System.ComponentModel.DataAnnotations;
using ServersideProgrammering.Models;

namespace ServersideProgrammering.Models
{
    public class Todo
    {
        [Key]
        public int ID { get; set; }
        [Required]
        public int UserID { get; set; }
        [Required]
        public string Name { get; set; }
        [Required]
        public string Description { get; set; }
    }
}
