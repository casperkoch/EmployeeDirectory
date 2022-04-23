<style scoped lang="scss">
.action {
  width: 100px;
}

/* Chrome, Safari, Edge, Opera */
input {
  &::-webkit-outer-spin-button,
  &::-webkit-inner-spin-button {
    -webkit-appearance: none;
    margin: 0;
  }
}

/* Firefox */
input[type=number] {
  -moz-appearance: textfield;
}

h2, h4 {
  text-transform: uppercase;
}
</style>

<template>
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-8 mt-3 mb-3">
                <h2 class="text-center">Medarbejdere</h2>
            </div>
        </div>

        <div class="row justify-content-center mb-3">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header"><h4 class="text-center mb-0">Liste</h4></div>

                    <div class="card-body">
                        <table class="table table-striped table-hover table-sm table-responsive">
                            <thead>
                                <tr>
                                    <th>Navn</th>
                                    <th>Email</th>
                                    <th>Tlf.</th>
                                    <th>Stilling</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr v-for="employee in employees" :key="employee.id">
                                    <td>{{ employee.name }}</td>
                                    <td>{{ employee.email }}</td>
                                    <td>{{ employee.phone }}</td>
                                    <td>{{ positionText(employee.position_id) }}</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

         <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header"><h4 class="text-center mb-0">Opret ny</h4></div>

                    <div class="card-body">
                        <form class="row g-3 needs-validation" v-on:submit.prevent="createEmployee">
                            <div class="col-md-6">
                                <label for="name" class="form-label">Navn</label>
                                <input type="text" class="form-control" id="name" name="name" v-model.trim="form.name"
                                    required minlength="1" maxlength="128"
                                    :class="{ 'is-invalid': errors.name }" aria-describedby="feedback-name" @input="delete errors.name">
                                    <div id="feedback-name" class="invalid-feedback" v-if="errors.name" v-text="errors.name"></div>
                            </div>
                            <div class="col-md-6">
                                <label for="email" class="form-label">Email</label>
                                <input type="email" class="form-control"
                                    id="email" name="email" v-model.trim="form.email"
                                    required minlength="1" maxlength="128"
                                    :class="{ 'is-invalid': errors.email }" aria-describedby="feedback-email" @input="delete errors.email">
                                    <div id="feedback-email" class="invalid-feedback" v-if="errors.email" v-text="errors.email"></div>
                            </div>
                            <div class="col-md-6">
                                <label for="phone" class="form-label">Tlf.</label>
                                <input type="number" class="form-control" id="phone" name="phone" v-model="form.phone"
                                    required min="10000000" max="99999999"
                                    :class="{ 'is-invalid': errors.phone }" aria-describedby="feedback-phone" @input="delete errors.phone">
                                    <div id="feedback-phone" class="invalid-feedback" v-if="errors.phone" v-text="errors.phone"></div>
                            </div>
                            <div class="col-md-6">
                                <label for="position_id" class="form-label">Stilling</label>
                                <select class="form-select" aria-label="Stilling" v-model="form.position_id"
                                    required
                                    :class="{ 'is-invalid': errors.position_id }" aria-describedby="feedback-position_id" @input="delete errors.position_id">
                                    <option v-for="position in positions" :value="position.id" :key="position.id">{{ position.title }}</option>
                                </select>
                                <div id="feedback-position_id" class="invalid-feedback" v-if="errors.position_id" v-text="errors.position_id"></div>
                            </div>

                            <div class="col-12">
                                <button type="submit" class="btn btn-primary action" :disabled="processing">
                                    <span v-if="processing" class="spinner-border spinner-border-sm" aria-hidden="true"></span>
                                    <span v-else>Opret</span>
                                </button>

                                <button type="button" class="btn btn-success action float-end" :disabled="processing" @click="fillRandom">
                                    <span v-if="processing" class="spinner-border spinner-border-sm" aria-hidden="true"></span>
                                    <span v-else>random()</span>
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
    export default {
        created() {     
            this.getEmployees();
            this.getPositions();
        },
        data() {
            return {
                employees: [],
                errors: {},
                form: {
                    name: '',
                    email: '',
                    phone: '',
                    position_id: '',
                },
                positions: [],
                processing: false,
            };
        },
        methods: {
            createEmployee() {
                this.processing = true;
                axios.post('/api/employees', this.form)
                    .then(response => {
                        this.employees.push(response.data);

                        // Clear form
                        Object.keys(this.form).forEach(key => this.form[key] = '');
                    })
                    .catch(error => {
                        const errors = error?.response?.data?.errors;
                        if (errors) {
                            // Only grab first error
                            Object.entries(errors).map(([key, value]) => errors[key] = value[0] );

                            this.errors = errors;
                            return;
                        }

                        console.log(errors);
                    })
                    .then(() => this.processing = false);
            },
            fillRandom() {
                this.processing = true;
                axios.get('/api/random')
                    .then(response => this.form = response.data)
                    .catch(error => console.log(error))
                    .then(() => this.processing = false);
            },
            getEmployees() {
                axios.get('/api/employees')
                    .then(response => this.employees = response.data)
                    .catch(error => console.log(error));
            },
            getPositions() {
                axios.get('/api/positions')
                    .then(response => this.positions = response.data)
                    .catch(error => console.log(error));
            },
            positionText(id) {
                return this.positions.find(p => p.id === id)?.title ?? '-';
            },
        },
    }
</script>
