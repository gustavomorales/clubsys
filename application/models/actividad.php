<?php if ( ! defined('BASEPATH')) exit ('No direct script access allowed');
	class Actividad extends CI_Model {

		public function AgregarActividad($info) {
			//Info = nombre, descripcion, fecha de inicio, id instructor, horarios(entrada, salida, dia)
			$nombre = $info[0];
			$descripcion = $info[1];
			$instructor = $info[2];
			$fecha = $info[3];


		
		$queryAgregar = $this->db->query('call agregar_actividad("'. $instructor .'", "'. $nombre . '", "' . $descripcion . '", "' . $fecha . '")');


			if( FALSE === $queryAgregar ) {
			    echo( "Error al agregar actividad.");
			} else {
			    echo( "Inclusión exitosa." );
			}
		}

		public function AgregarHorarios($info) {
			$actividad = $info[0];
			$dia = $info[1];
			$llegada = $info[2];
			$salida = $info[3];

			$queryAgregar = $this->db->query('call agregar_horario("' . $actividad . '", "'. $dia . '", "' . $llegada . '", "' . $salida . '")');

			if( FALSE === $queryAgregar ) {
			    echo( "Error al agregar horario." );
			} else {
			    echo( "Inclusión exitosa." );
			}
		}

		 

		public function NuevosHorarios($nombre, $implementacion) {
			$this->db->insert('historial_horario');
		}

		public function DevolverActividades() {
			$query = $this->db->get('lista_actividades');

			return $query->result_array();
		}

		public function DevolverInstructores() {
			$this->db->select();
			$this->db->from('lista_usuarios');
			$this->db->where('tipoId = 3');
			$query = $this->db->get();

			return $query->result_array();
		}
	}

?>