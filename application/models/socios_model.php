<?php if ( ! defined('BASEPATH')) exit ('No direct script access allowed');
class Socios_model extends CI_model {
	public function __construct() {
		$this->load->database();
	}

	public function set_socios($detalles) {
		$query = $this->db->query("call agregar_usuario('{$detalles['tipo']}', '{$detalles['nombres']}', '{$detalles['apellido']}', '1234', '{$detalles['direccion']}', '{$detalles['fechaNacimiento']}')");
	}

	public function get_socios($string = FALSE) {
		$query_string = "SELECT * FROM `lista_usuarios`";

		if ($string) {
			$query_string .= " WHERE `Apellidos y nombres` LIKE '%{$string}%'";
		}

		$query = $this->db->query($query_string);

		return $query->result_array();
	}

	public function get_sociosxtipo($tipoId) {
		$this->db->select('*');
		$this->db->from('lista_usuarios');
		$this->db->where("tipoId = {$tipoId}");
		$query = $this->db->get();

		return $query->result_array();
	}

	public function update_socio($data) {
		$info = array(
			'tipo_id' => $data['tipo'],
			'nombres' => $data['nombres'],
			'apellido' => $data['apellidos'],
			'direccion' => $data['direccion'],
			'fecha_nacimiento' => $data['nacimiento']
			);
		$this->db->where('id', $data['id']);
		$this->db->update('usuario', $info); 
	}

	public function get_tipos(){
		$query = $this->db->get('tipo_usuario');

		return $query->result_array();
	}

	public function delete_socio($id) {
		$this->db->delete('usuario', array('id' => $id));
		if ($this->db->affected_rows() > 0)
			return true;
		else
			return false;
	}
}