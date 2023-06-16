###### tags: `REACT套件`

```javascript!
import React, { useEffect, useState } from "react";
import { useForm, Controller } from "react-hook-form";
import {
  Container,
  Form,
  FormGroup,
  Label,
  FormFeedback,
  Button,
  Col,
} from "reactstrap";

const wrapperStyle = {
  width: "16px",
  height: "16px",
  border: "1px solid black",
  cursor: "pointer",
  display: "flex",
  justifyContent: "center",
  alignItems: "center",
};


interface IEvent{
  target:{
    value:any
  }
}
const CheckBox = ({
  value,
  onChange,
}: {
  value?: boolean;
  onChange?: (v: IEvent) => void;
}) => {
  return (
    <div
      onClick={() => onChange?.({ target: { value: !value } })}
      style={wrapperStyle}
    >
      {!!value && <span>X</span>}
    </div>
  );
};

let counter = 0;

const ReactHookFrom: React.FC = () => {
  const {
    register,
    handleSubmit,
    watch,
    control,
    setError,
    formState: { errors },
  } = useForm({
    mode: "onBlur",
    reValidateMode: "onChange",
  });

  const [checked, setChecked] = useState(false);
  const [firstName, lastName] = watch(["firstName", "lastName"]);
  useEffect(() => {
    if (!!firstName && !!lastName && firstName !== lastName) {
      console.log("firstName", firstName);
      console.log("lastName", lastName);
      setError("lastName", { type: "custom", message: "不一樣喔" });
    }
  }, [firstName, lastName, setError]);

  const onSubmit = (d: any) => {
    alert(JSON.stringify(d));
  };

  return (
    <div className="App">
      {/* <CheckBox value={checked} onChange={setChecked} /> */}
      <Container
        style={{ height: "100vh" }}
        className="d-flex justify-content-center align-items-center  "
      >
        <Form className="w-75" onSubmit={handleSubmit(onSubmit)}>
          <Controller
            name="agree"
            control={control}
            defaultValue={false}
            render={({ field, fieldState, formState }) => (
              // <CheckBox value={field.value} onChange={field.onChange} />
              <CheckBox {...field} />
            )}
          />

          <FormGroup row>
            <Label sm={2} for="exampleEmail">
              First Name
            </Label>
            <Col sm={10}>
              <input
                {...register("firstName", {
                  minLength: { value: 2, message: "要大於2" },
                })}
                className="form-control"
              />
              {!!errors.firstName && (
                <p>{errors.firstName?.message?.toString() || "required"}</p>
              )}
            </Col>
          </FormGroup>

          <FormGroup row>
            <Label sm={2}>Last Name</Label>
            <Col sm={10}>
              <input
                {...register("lastName", { required: "last is required" })}
                className="form-control"
              />
              {!!errors.lastName && (
                <p>{errors.lastName?.message?.toString() || "required"}</p>
              )}

              <FormFeedback>Oh noes! that name is already taken</FormFeedback>
            </Col>
          </FormGroup>
          <FormGroup row className="position-relative">
            <Label sm={2} for="examplePassword">
              Age
            </Label>
            <Col sm={10}>
              <input
                {...register("age", {
                  min: { value: 10, message: ">10" },
                  max: 30,
                })}
                className="form-control"
              />
              {!!errors.age && (
                <p>{errors.age?.message?.toString() || "Invalid"}</p>
              )}
            </Col>
          </FormGroup>
          <Button className="mt-3" color="secondary">
            提交
          </Button>
          <p>Render:{counter++}</p>
        </Form>
      </Container>
    </div>
  );
};

export default ReactHookFrom;

```