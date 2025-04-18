import mongoose from "mongoose";
import bcrypt from "bcryptjs";

const { Schema } = mongoose;

// Define the Profile Subschema
const profileSchema = new Schema(
  {
    full_name: {
      type: String,
      required: true,
      trim: true,
    },
    date_of_birth: {
      type: Date,
    },
    phone_number: {
      type: String,
      trim: true,
    },
  },
  { _id: false },
);

// Define the User Schema
const userSchema = new Schema(
  {
    email: {
      type: String,
      required: true,
      unique: true,
      trim: true,
      lowercase: true,
      match: [/.+\@.+\..+/, "Please fill a valid email address"],
    },
    password: {
      type: String,
      required: true,
      minlength: 6,
    },
    role: {
      type: String,
      enum: ["user", "admin"],
      default: "user",
    },
    profile: {
      type: profileSchema,
      required: true,
    },
    code: {
      type: String,
    },
    codeExpires: {
      type: Date,
    },
  },
  {
    timestamps: true,
  },
);

// Pre-save hook to hash passwords
userSchema.pre("save", async function (next) {
  if (!this.isModified("password")) {
    return next();
  }
  try {
    const salt = await bcrypt.genSalt(10);
    this.password = await bcrypt.hash(this.password, salt);
    next();
  } catch (error) {
    next(error);
  }
});

// Method to compare passwords
userSchema.methods.matchPassword = async function (enteredPassword) {
  return await bcrypt.compare(enteredPassword, this.password);
};

// Create and Export the User Model
const User = mongoose.model("User", userSchema);

export default User;
