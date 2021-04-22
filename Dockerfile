FROM nvidia/cuda:11.1-base

ARG USER=Alex
RUN apt-get update

# install env
RUN DEBIAN_FRONTEND="noninteractive" apt-get -y install tzdata
RUN apt-get install -y apt-utils && \
    apt-get install -y curl && \
    apt-get install -y git && \
    apt-get install -y build-essential && \
    apt-get install -y cmake && \
    apt-get install -y clang && \
    apt-get install -y libopencv-dev

# install python3
RUN apt-get install -y python3.8 && \
    apt-get install -y python3-pip && \
    apt-get install -y python-dev

RUN pip3 install numpy

# install clang
RUN apt-get install -y clang

# install opencv with cuda
RUN mkdir opencv_install && \
    cd opencv_install

RUN git clone https://github.com/opencv/opencv.git
RUN git clone https://github.com/opencv/opencv_contrib.git
RUN mkdir build && \
    cd build
    
RUN cmake -D CMAKE_BUILD_TYPE=Release \
    -D OPENCV_GENERATE_PKGCONFIG=YES \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D WITH_TBB=ON \
    -D WITH_V4L=ON \
    -D INSTALL_C_EXAMPLES=ON \
    -D WITH_CUBLAS=1 \
    -D WITH_LIBV4L=ON \
    -D WITH_GSTREAMER=ON \
    -D WITH_NVCUVID=ON \
    -D FORCE_VTK=ON \
    -D WITH_XINE=ON \
    -D WITH_CUDA=ON \
    -D CUDA_ARCH_BIN=11.1 \
    -D CUDA_NVCC_FLAGS="-D_FORCE_INLINES --expt-relaxed-constexpr" \
    -D ENABLE_FAST_MATH=1 \
    -D CUDA_FAST_MATH=1 \
    -D WITH_GDAL=ON \
    -D INSTALL_PYTHON_EXAMPLES=ON \
    -D PYTHON_EXECUTABLE=/usr/bin/python3 \
    -D OPENCV_PYTHON3_INSTALL_PATH=/usr/local/lib/python3.8/dist-packages \
    -DOPENCV_EXTRA_MODULES_PATH=../opencv_contrib/modules \
    ../opencv

RUN make && \
    make install && \
    cd .. && \
    cd ..

COPY . .
RUN pip3 install -r requirements.txt
CMD python3 app.py
    
