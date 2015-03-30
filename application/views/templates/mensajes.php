                    <div class="col-sm-12">
                    <?php
                    if ($this->session->flashdata('success')) {
                        echo '<div class="alert alert-success">' . $this->session->flashdata('success') . '</div>';
                    }
                    if ($this->session->flashdata('warning')) {
                        echo '<div class="alert alert-warning">' . $this->session->flashdata('warning') . '</div>';
                    }
                    if ($this->session->flashdata('danger')) {
                        echo '<div class="alert alert-danger">' . $this->session->flashdata('danger') . '</div>';
                    }
                    ?>
                    </div>