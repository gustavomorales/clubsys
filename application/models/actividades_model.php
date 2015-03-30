<?php if ( ! defined('BASEPATH')) exit ('No direct script access allowed');
class Actividades_model extends CI_Model {

	public function set_actividad($data) {
			//Info = nombre, descripcion, fecha de inicio, id instructor, horarios(entrada, salida, dia)
		$nombre = $data['nombre'];
		$descripcion = $data['descripcion'];
		$instructor = $data['instructor'];
		$fecha = $data['fecha'];

		$sql = "call agregar_actividad(?, ?, ?, ?)";

		$queryAgregar = $this->db->query($sql, array($instructor, $nombre, $descripcion, $fecha));

		if ($this->db->affected_rows() > 0)
			return true;
		else
			return false;
	}

	public function set_horario($info) {
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



	public function set_horarios($nombre, $implementacion) {
		$this->db->insert('historial_horario');
	}

	public function get_actividades() {
		$query = $this->db->get('lista_actividades');

		return $query->result_array();
	}

	public function get_instructores() {
		$this->db->select();
		$this->db->from('lista_usuarios');
		$this->db->where('tipoId = 3');
		$query = $this->db->get();

		return $query->result_array();
	}

	public function update_actividad($data) {
		$info = array(
			'nombre' => $data['nombre'],
			'instructor_id' => $data['instructor'],
			'descripcion' => $data['descripcion'],

			);
		$this->db->where('id', $data['id']);
		$this->db->update('actividad', $info);
				if ($this->db->affected_rows() > 0)
			return true;
		else
			return false; 
	}

	public function delete_actividad($id) {
		$this->db->delete('actividad', array('id' => $id));

		if ($this->db->affected_rows() > 0)
			return true;
		else
			return false;
	}

	public function get_usuarios_actividad($id) {
			$query = $this->db->get_where('lista_participantes',array('id_actividad' => $id));
			//chequear fecha de finalizacion

			return $query->result_array();
	}

	public function get_actividades_usuario($id) {
		$query = $this->db->get_where('lista_participantes',array('id_usuario' => $id));
		//chequear fecha de finalizacion
		return $query->result_array();
	}

	public function inscribir_actividad($usuario, $actividad) {
		$sql = ("call inscribir_a_actividad(?, ?)");
		$this->db->query($sql, array($usuario, $actividad));
	}

	public function desinscribir_actividad($usuario, $actividad) {
		$sql = ("call desinscribir_a_actividad(?, ?)");
		$this->db->query($sql, array($actividad, $usuario));
	}
}