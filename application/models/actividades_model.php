<?php if ( ! defined('BASEPATH')) exit ('No direct script access allowed');
class Actividades_model extends CI_Model {

	public function set_actividad($data) {
		//Info = nombre, descripcion, fecha de inicio, id instructor, horarios(entrada, salida, dia)
		$nombre = $data['nombre'];
		$descripcion = $data['descripcion'];
		$instructor = $data['instructor'];
		$fecha = $data['fecha'];

		$existe = $this->db->get_where('actividad', array('nombre' => $nombre));

		if ($existe->result_array()) {
			return array('danger','No puede haber dos actividades con el mismo nombre.');
		}
		else {
			$sql = "call agregar_actividad(?, ?, ?, ?)";
			$this->db->query($sql, array($instructor, $nombre, $descripcion, $fecha));

			if($this->db->affected_rows() > 0) {
				return array('success', 'Actividad creada con &eacute;xito');
			} else {
				return array('danger', 'Error al intentar agregar actividad.');
			}
		}
	}

	public function update_actividad($data, $nombreActual) {
		$id = $data['id'];
		$nombre = $data['nombre'];
		$descripcion = $data['descripcion'];
		$instructor = $data['instructor'];

		if ($nombre != $nombreActual) {
			$existe = $this->db->get_where('actividad', array('nombre' => $nombre));
			if ($existe->result_array()) {
				$mensaje = htmlentities("No puede haber dos actividades con el mismo nombre ({$nombre}).", ENT_COMPAT, 'UTF-8');
				return array('danger', $mensaje);
			}
		}

		$sql = "update `actividad` SET `instructor_id`= ?,`nombre`= ?,`descripcion`= ? WHERE `id` = $id";
		$this->db->query($sql, array($instructor, $nombre, $descripcion));
		
		return array('success', 'Actividad modificada con &eacute;xito');
		
	}

	public function set_historial_horario($actividad, $implementacion) {
		$sql = "call agregar_historial_horario(?, ?)";
		$this->db->query($sql, array($actividad, $implementacion));
	}

	public function set_horarios($data) {
		foreach ($data as $horario) {
			$actividad = $horario['actividad'];
			$dia = $horario['dia'];
			$entrada = $horario['entrada'];
			$salida = $horario['salida'];

			$sql = ("call agregar_horario(?, ?, ?, ?)");


			$this->db->query($sql, array($actividad, $dia, $entrada, $salida));
		}
	}

	public function get_actividades() {
		$query = $this->db->get('lista_actividades');

		return $query->result_array();
	}

	public function get_instructores() {
		$this->db->select();
		$this->db->from('lista_usuarios');
		$this->db->where('tipo_id = 3');
		$query = $this->db->get();

		return $query->result_array();
	}

	public function delete_actividad($id) {
		$this->db->delete('historial_horario', array('actividad_id' => $id));
		$this->db->delete('actividad', array('id' => $id));

		if ($this->db->affected_rows() > 0)
			return array('success', 'Actividad eliminada exitosamente.');
		else
			return array('danger', 'Error al intentar eliminar actividad.');
	}

	public function get_usuarios_actividad($id) {
		$this->db->select('actividad_id, usuario_id, nombre_actividad as actividad, participante');
		$this->db->from('lista_participantes');
		$this->db->where('actividad_id', $id);
		$this->db->where('finalizacion > "'. date('Y-m-d') .'"');

		$query = $this->db->get();

		return $query->result_array();
	}

	public function get_actividades_usuario($id) {
		$this->db->select('actividad_id, nombre_actividad as actividad, participante');
		$this->db->from('lista_participantes');
		$this->db->where('usuario_id', $id);
		$this->db->where('finalizacion > "'. date('Y-m-d') .'"');

		$query = $this->db->get();

		return $query->result_array();
	}

	public function inscribir_actividad($usuario, $actividad) {
		$existe = $this->db->get_where('actividad_por_usuario', array('usuario_id' => $usuario, 'actividad_id' => $actividad));
		if ($existe->result_array()) {
			$registro = $existe->result_array();
			if ($registro[0]['fecha_finalizacion'] > date('Y-m-d'))
				return array('danger', 'Socio ya est&aacute; inscripto.');
			else {
				$this->db->update('actividad_por_usuario', array('fecha_finalizacion' => '9999-12-31', 'fecha_inicio' => date('Y-m-d')), array('usuario_id' => $usuario, 'actividad_id' => $actividad));
				if ($this->db->affected_rows() > 0)
					return array('success', 'Alta exitosa.');
				else
					return array('danger', 'Error en la base de datos al intentar dar de alta.');
			}
		}
		else
		{
			$sql = ("call inscribir_a_actividad(?, ?)");
			$this->db->query($sql, array($usuario, $actividad));
			if ($this->db->affected_rows() > 0)
				return array('success', 'Alta exitosa.');
			else
				return array('danger', 'Error en la base de datos al intentar dar de alta.');
		}
	}

	public function desinscribir_actividad($usuario, $actividad) {
		$sql = ("call desinscribir_a_actividad(?, ?)");
		$this->db->query($sql, array($actividad, $usuario));
		if ($this->db->affected_rows() > 0)
			return array('success', 'Actividad dado de baja.');
		else
			return array('danger', 'Error en la base de datos al intentar dar de baja.');
	}
	
}