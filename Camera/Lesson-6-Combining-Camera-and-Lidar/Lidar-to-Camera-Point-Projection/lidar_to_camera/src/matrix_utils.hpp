#ifndef MATRIX_UTILS_HPP
#define MATRIX_UTILS_HPP

#include <opencv2/core.hpp>
#include <iostream>
#include <iomanip>
#include <vector>
#include <algorithm>

namespace matrix_utils {

void printMatrix(cv::Mat matrix) {
        std::vector<int> maxColumnWidths(matrix.cols, 0);

        for (int j = 0; j < matrix.cols; ++j) {
            for (int i = 0; i < matrix.rows; ++i) {
                std::stringstream ss;
                ss << matrix.at<double>(i, j);
                maxColumnWidths[j] = std::max(maxColumnWidths[j], static_cast<int>(ss.str().length()));
            }
        }

        std::cout << "[" << std::endl;
        for (int i = 0; i < matrix.rows; ++i) {
            std::cout << " [ ";
            for (int j = 0; j < matrix.cols; ++j) {
                std::stringstream ss;
                ss << matrix.at<double>(i, j);
                std::cout << std::setw(maxColumnWidths[j]) << ss.str() << " ";
            }
            std::cout << "]" << std::endl;
        }
        std::cout << "]" << std::endl;
    }

} // namespace matrix_utils

#endif // MATRIX_UTILS_HPP
